function Write-ConfigurationSection {
    param(
        [string]$Server
    )

    Write-Output "## :gear: Configuration"
    Write-Output ""

    Write-Output "| Proxmox V9.2           | User/Pwd                   |"
    Write-Output "|------------------------|----------------------------|"
    Write-Output "| ${Server}              | root/Boreal@2️⃣02️⃣6          |"
    Write-Output ""

}


function Write-LabHeader {
    param(
        [hashtable]$FeedbackLookup = @{}
    )

    Write-Output ""
    Write-Output "## :a: Présence"
    Write-Output ""

    if ($FeedbackLookup.Count -gt 0) {
        Write-Output "|:hash:| Boréal :id: | README.md | images | Appréciation | Commentaires | :link: IP |"
        Write-Output "|------|-------------|-----------|--------|--------------|--------------|-----------|"
    }
    else {
        Write-Output "|:hash:| Boréal :id: | README.md | images | :link: IP |"
        Write-Output "|------|-------------|-----------|--------|-----------|"
    }
}

function Write-LabStudentRow {
    param(
        [int]$Index,
        [string]$StudentID,
        [string]$GitHubLink,
        [string]$ReadmePath,
        [hashtable]$Checks,
        [hashtable]$FeedbackLookup = @{},
        [string]$Server
    )

    if ($FeedbackLookup.Count -gt 0) {

        $Feedback = $FeedbackLookup[$StudentID]

        $Appreciation = if ($Feedback) { $Feedback.Appreciation } else { "" }
        $Comments     = if ($Feedback) { $Feedback.Comments } else { "" }

        Write-Output "| $Index | [$StudentID](../$ReadmePath) :point_right: $GitHubLink | $($Checks.README) | $($Checks.Images) | $Appreciation | $Comments | $($Server) |"
    }
    else {

        Write-Output "| $Index | [$StudentID](../$ReadmePath) :point_right: $GitHubLink | $($Checks.README) | $($Checks.Images) | $($Server) |"
    }
}

function Get-RdpStatus {
    param(
        [Parameter(Mandatory)]
        [string]$ServerIP,

        [int]$Timeout = 2
    )

    try {
        & nc -z -w $Timeout $ServerIP 3389 *> $null

        if ($LASTEXITCODE -eq 0) {
            return ":white_check_mark:"
        }

        return ":x:"
    }
    catch {
        return ":x:"
    }
}
