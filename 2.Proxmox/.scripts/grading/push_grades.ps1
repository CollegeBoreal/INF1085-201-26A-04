# =====================================================================
# SCRIPT ENTRYPOINT
# =====================================================================
# This script reads participation data from Markdown,
# maps students to Moodle users, builds rubric payloads,
# and submits grades to the LMS.
#
# All assignment-specific IDs (assignmentId, criterionid, levelids)
# are loaded from rubric.json — never hardcoded here.
# =====================================================================

# Exit immediately on any unhandled error
# (Prevents partial or inconsistent grading)
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------
# LOAD DEPENDENCIES
# ---------------------------------------------------------------------

# 0.PlanDeCours/.scripts/grading -> repo root
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "../../..")

. (Join-Path $RepoRoot ".scripts/students.ps1")
. (Join-Path $RepoRoot ".scripts/grading/functions.ps1")
. (Join-Path $RepoRoot ".scripts/grading/WSFunctions.ps1")

# =====================================================================
# LOAD RUBRIC CONFIG (assignment-specific, sourced from API)
# =====================================================================
$config = Get-Content "$PSScriptRoot/rubric.json" -Raw | ConvertFrom-Json
$LMSAssignmentID = $config.assignmentId
$Criteria = $config.criteria
$ImpliedPass = $config.impliedPass   # may be $null

# ---------------------------------------------------------------------
# LOAD FEEDBACK (per-student remarks from feedback.csv)
# ---------------------------------------------------------------------
# Keyed by StudentID → { Appreciation, Comments }
$FeedbackLookup = @{}
$feedbackPath = Join-Path $PSScriptRoot "feedback.csv"
if (Test-Path $feedbackPath) {
    Import-Csv $feedbackPath | ForEach-Object {
        $FeedbackLookup[$_.StudentID] = $_
    }
}

# ---------------------------------------------------------------------
# FETCH GRADABLE USERS FROM LMS
# ---------------------------------------------------------------------
# Retrieves all students eligible for grading in the LMS course
$responseLMS = Get-LMSGradableUsers -LMS_COURSE $LMS_COURSE

# Builds a lookup table keyed by Boréal ID
# {
#   "123456789" = { moodleId, email }
# }
$LMSStudents = Get-LMSStudentInfo -LMSResponse $responseLMS

# ---------------------------------------------------------------------
# READ PARTICIPATION FILES
# ---------------------------------------------------------------------
# File list is driven by rubric.json so it varies per assignment
$participation = $config.files | ForEach-Object {
    Get-ParticipationGrades -Path $_ -Criteria $Criteria -ImpliedPass $ImpliedPass
}

# Optional debug output to validate extracted data
if ($DEBUG) {
    Write-Output $participation
    Write-Host "Total entries:" $participation.Count
}

# ---------------------------------------------------------------------
# PROCESS EACH STUDENT ENTRY
# ---------------------------------------------------------------------
foreach ($entry in $participation) {

    # Skip entries missing a Boréal ID
    # (Cannot be matched to LMS users)
    if (-not $entry.borealId) {
        Write-Warning "Missing borealId in entry: $entry"
        continue
    }

    # Skip students not found in LMS
    if (-not $LMSStudents.ContainsKey($entry.borealId)) {
        Write-Warning "No Moodle user found for ID: $($entry.borealId)"
        continue
    }

    # Retrieve Moodle user ID for grade submission
    $moodleId = $LMSStudents[$entry.borealId].moodleId
    if ($DEBUG) {
        Write-Output $moodleId, $entry.borealId
    }

    # Merge per-student feedback remark into entry
    # (used as the remark on criteria whose rubric.json "remark" points to "comments")
    if ($FeedbackLookup.ContainsKey($entry.borealId)) {
        $entry | Add-Member -NotePropertyName comments `
            -NotePropertyValue $FeedbackLookup[$entry.borealId].Comments `
            -Force
    }

    # Build LMS-compatible rubric payload from config-driven criteria
    $rubric = New-LMSRubricFromEntry -Entry $entry -Criteria $Criteria

    # -----------------------------------------------------------------
    # SUBMIT GRADE TO LMS
    # -----------------------------------------------------------------
    $response = Send-LMSRubricGrade `
        -LMS_URL $env:LMS_URL `
        -TOKEN $env:API_SYNC_TOKEN `
        -AssignmentId $LMSAssignmentID `
        -UserId $moodleId `
        -Rubric $rubric

    # Output confirmation / API response
    Write-Output "--------------------------------------"
    Write-Output $response
}
