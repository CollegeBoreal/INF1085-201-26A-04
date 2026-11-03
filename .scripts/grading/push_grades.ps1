# Exit on error
$ErrorActionPreference = "Stop"

# . .scripts/students.ps1
# . .scripts/grading/functions.ps1

# ---------------------------------------------------------------------
# LOAD DEPENDENCIES
# ---------------------------------------------------------------------

# repo/0.PlanDeCours/.scripts/grading -> repo
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "../../")

. (Join-Path $RepoRoot ".scripts/students.ps1")
. (Join-Path $RepoRoot ".scripts/grading/functions.ps1")


$responseLMS = Get-LMSGradableUsers -LMS_COURSE $LMS_COURSE
$LMSStudents = Get-LMSStudentInfo -LMSResponse $responseLMS

foreach ($entry in $STUDENTS) {
    $parts = $entry -split '\|'
    $StudentID = $parts[0]

    Write-Output $LMSStudents[$StudentID].moodleId
    Write-Output $LMSStudents[$StudentID].email

}


