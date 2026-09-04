# =====================================================================
# RUBRIC / EMOJI HELPERS
# =====================================================================
# These helper functions translate README or grading emojis into
# rubric level IDs used by the LMS.
# =====================================================================
function Get-RubricLevelIdFromReadmeEmoji {
    param (
        [Parameter(Mandatory)]
        [string]$Emoji,

        [Parameter(Mandatory)]
        [int[]]$Levels
    )

    $Emoji = $Emoji.Trim()

    switch ($Levels.Count) {

        3 {
            $fail   = $Levels[0]
            $silver = $Levels[1]
            $gold   = $Levels[2]

            switch -Regex ($Emoji) {
                ':x:|❌'               { return $fail }
                ':2nd_place_medal:|🥈' { return $silver }
                ':1st_place_medal:|🥇' { return $gold }
                default {
                    throw "Unknown README emoji for 3-level rubric: $Emoji"
                }
            }
        }

        4 {
            $fail   = $Levels[0]
            $bronze = $Levels[1]
            $silver = $Levels[2]
            $gold   = $Levels[3]

            switch -Regex ($Emoji) {
                ':x:|❌'               { return $fail }
                ':3rd_place_medal:|🥉' { return $bronze }
                ':2nd_place_medal:|🥈' { return $silver }
                ':1st_place_medal:|🥇' { return $gold }
                default {
                    throw "Unknown README emoji for 4-level rubric: $Emoji"
                }
            }
        }

        5 {
            $fail   = $Levels[0]
            $bronze = $Levels[1]
            $silver = $Levels[2]
            $gold   = $Levels[3]
            $champ  = $Levels[4]

            switch -Regex ($Emoji) {
                ':x:|❌'               { return $fail }
                ':3rd_place_medal:|🥉' { return $bronze }
                ':2nd_place_medal:|🥈' { return $silver }
                ':1st_place_medal:|🥇' { return $gold }
                ':trophy:|🏆'          { return $champ }
                default {
                    throw "Unknown README emoji for 5-level rubric: $Emoji"
                }
            }
        }

        default {
            throw "Levels must contain either 3 values [fail,silver,gold] or 4 values [fail,bronze,silver,gold] or 5 values [fail,bronze,silver,gold,trophy]"
        }
    }
}

function Get-RubricLevelIdFromEmoji {
    <#
        Simple pass/fail emoji mapping.

        ❌ or :x:      → Fail level
        Any other emoji → Pass level
    #>
    param (
        [Parameter(Mandatory)]
        [string]$Emoji,

        [Parameter(Mandatory)]
        [int]$FailLevelId,

        [Parameter(Mandatory)]
        [int]$PassLevelId
    )

    $Emoji = $Emoji.Trim()

    # Explicit failure detection
    if ($Emoji -match ':x:' -or $Emoji -match '❌') {
        return $FailLevelId
    }

    # Default to pass
    return $PassLevelId
}

# =====================================================================
# LMS INTEGRATION
# =====================================================================

function Get-LMSGradableUsers {
    <#
        Retrieves all gradable users for a given LMS course
        using Moodle's core_grades_get_gradable_users API.
    #>
    param (
        [Parameter(Mandatory)]
        [int]$LMS_COURSE
    )

    # Ensure required environment variables are present
    if (-not $env:LMS_URL -or -not $env:API_SYNC_TOKEN) {
        throw "LMS_URL or API_SYNC_TOKEN is not set!"
    }

    try {
        $responseLMS = Invoke-RestMethod -Method Post `
            -Uri "https://$($env:LMS_URL)/webservice/rest/server.php" `
            -Body @{
                wstoken            = $env:API_SYNC_TOKEN
                wsfunction         = "core_grades_get_gradable_users"
                courseid           = $LMS_COURSE
                moodlewsrestformat = "json"
            }

        return $responseLMS

    } catch {
        throw "Failed to call Moodle API: $($_.Exception.Message)"
    }
}

# =====================================================================
# STUDENT DATA PROCESSING
# =====================================================================

function Get-LMSStudentInfo {
    <#
        Converts the LMS response into a lookup table keyed by idnumber.

        Output format:
        @{
            "studentId" = @{
                moodleId = 123
                email    = student@example.com
            }
        }
    #>
    param (
        [Parameter(Mandatory)]
        [object]$LMSResponse
    )

    $LMSStudents = @{}

    if (-not $LMSResponse.users) {
        throw "LMSResponse does not contain a 'users' property."
    }

    $LMSResponse.users | Where-Object { $_.idnumber } | ForEach-Object {
            $LMSStudents[$_.idnumber] = [PSCustomObject]@{
                moodleId = $_.id
                email    = $_.email
            }
        }

    return $LMSStudents
}

# =====================================================================
# GRADING / RUBRIC SUBMISSION
# =====================================================================

function Send-LMSRubricGrade {
    <#
        Submits a rubric-based grade to the LMS using a custom
        local_gradesaver_save_grade endpoint.

        Rubric entries must contain:
        - criterionid
        - levelid
        - remark (optional)
    #>
    param (
        [Parameter(Mandatory)]
        [string]$LMS_URL,

        [Parameter(Mandatory)]
        [string]$TOKEN,

        [Parameter(Mandatory)]
        [int]$AssignmentId,

        [Parameter(Mandatory)]
        [int]$UserId,

        [Parameter(Mandatory)]
        [array]$Rubric,

        [int]$AttemptNumber = 0,

        [string]$WorkflowState = "graded"
    )

    # -------------------------
    # BUILD BASE REQUEST PAYLOAD
    # -------------------------
    $body = @{
        wstoken            = $TOKEN
        wsfunction         = "local_gradesaver_save_grade"
        moodlewsrestformat = "json"
        assignmentid       = $AssignmentId
        userid             = $UserId
        attemptnumber      = $AttemptNumber
        workflowstate      = $WorkflowState
    }

    # -------------------------
    # DYNAMIC RUBRIC POPULATION
    # -------------------------
    for ($i = 0; $i -lt $Rubric.Count; $i++) {
        $entry = $Rubric[$i]

        # Ensure rubric structure is valid
        if (-not $entry.criterionid -or -not $entry.levelid) {
            throw "Invalid rubric entry at index $i"
        }

        $body["rubric[criteria][$i][criterionid]"] = $entry.criterionid
        $body["rubric[criteria][$i][levelid]"]     = $entry.levelid
        $body["rubric[criteria][$i][remark]"]      = $entry.remark
    }

    if ($DEBUG) { $body | ConvertTo-Json -Depth 10 }

    # -------------------------
    # SEND REQUEST TO MOODLE
    # -------------------------
    try {
        $response = Invoke-RestMethod -Method Post `
            -Uri "https://$LMS_URL/webservice/rest/server.php" `
            -Body $body

        return $response
    }
    catch {
        throw "Moodle API call failed: $($_.Exception.Message)"
    }
}