#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"


# Importer la liste des étudiants
. ../.scripts/students.ps1

# Importer les fonctions
. ../.scripts/functions.ps1
. ../.scripts/commons.ps1

# Importer les fonctions du lab
. .scripts/functions.ps1

# --------------------------------------
# FEEDBACK
# --------------------------------------

$FeedbackLookup = Get-FeedbackLookup -Students $STUDENTS

Write-LabParticipationHeader
Write-PresenceHeader -FeedbackLookup $FeedbackLookup

$s = 0

for ($i = 0; $i -lt $STUDENTS.Count; $i++) {

    $parts = $STUDENTS[$i] -split '\|'

    $StudentID = $parts[0]
    $GitHubID = $parts[1]
    $AvatarID = $parts[2]

    $paths = Get-StudentPaths -StudentID $StudentID
    $checks = Get-StudentChecks -Paths $paths
    $url = Get-GitHubAvatarLink -GitHubID $GitHubID -AvatarID $AvatarID

    Write-LabStudentRow `
        -Index ($i + 1) `
        -StudentID $StudentID `
        -GitHubLink $url `
        -ReadmePath $Paths.README `
        -Checks $Checks `
        -FeedbackLookup $FeedbackLookup 

    if (Test-AllRequiredFilesPresent -Checks $checks) {
        $s++
    }

}

Write-Summary -SuccessCount $s -TotalCount $i

