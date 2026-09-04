#!/usr/bin/env pwsh

# ---------- Fonctions ----------

function Get-StudentPaths {
    param(
        [string]$StudentID
    )

    return @{
        README   = "$StudentID/README.md"
        Images   = "$StudentID/images"
    }
}

function Get-StudentChecks {
    param(
        [hashtable]$Paths
    )

    return @{
        README    = Test-CommonItemExists -Path $Paths.README -IsReadme
        Images    = Test-CommonItemExists -Path $Paths.Images
    }
}

function Test-AllRequiredFilesPresent {
    param(
        [hashtable]$Checks
    )

    $validReadmeValues = @(
        ":1st_place_medal:",
        ":2nd_place_medal:"
    )

    return (
        $Checks.README -in $validReadmeValues -and
        $Checks.Images -eq ":heavy_check_mark:"
    )
}

function Write-PresenceHeader {
    param(
        [hashtable]$FeedbackLookup = @{}
    )

    Write-Output ""
    Write-Output "## :a: Présence"
    Write-Output ""

    if ($FeedbackLookup.Count -gt 0) {
        Write-Output "|:hash:| Boréal :id: | README.md | images | Appréciation | Commentaires |"
        Write-Output "|------|-------------|-----------|--------|--------------|--------------|"
    }
    else {
        Write-Output "|:hash:| Boréal :id: | README.md | images |"
        Write-Output "|------|-------------|-----------|--------|"
    }
}

function Write-StudentRow {
    param(
        [int]$Index,
        [string]$StudentID,
        [string]$GitHubLink,
        [string]$ReadmePath,
        [hashtable]$Checks,
        [hashtable]$FeedbackLookup = @{}
    )

    if ($FeedbackLookup.Count -gt 0) {

        $Feedback = $FeedbackLookup[$StudentID]

        $Appreciation = if ($Feedback) { $Feedback.Appreciation } else { "" }
        $Comments     = if ($Feedback) { $Feedback.Comments } else { "" }

        Write-Output "| $Index | [$StudentID](../$ReadmePath) :point_right: $GitHubLink | $($Checks.README) | $($Checks.Images) | $Appreciation | $Comments |"
    }
    else {

        Write-Output "| $Index | [$StudentID](../$ReadmePath) :point_right: $GitHubLink | $($Checks.README) | $($Checks.Images) |"
    }
}

# --------------------------------------
# FEEDBACK
# --------------------------------------

function Get-FeedbackLookup {
    param(
        [string[]]$Students,
        [string]$FeedbackFile = ".scripts/grading/feedback.csv"
    )

    $FeedbackLookup = @{}

    if (-not (Test-Path $FeedbackFile)) {

        $Students |
            ForEach-Object {
                [PSCustomObject]@{
                    StudentID    = (($_ -split '\|')[0]).Trim()
                    Appreciation = ":x:"
                    Comments     = "À corriger"
                }
            } |
            Export-Csv $FeedbackFile -NoTypeInformation

        Write-Host "Created $FeedbackFile"
    }

    Import-Csv $FeedbackFile | ForEach-Object {
        $FeedbackLookup[$_.StudentID] = $_
    }

    return $FeedbackLookup
}