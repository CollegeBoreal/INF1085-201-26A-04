# Enables verbose/debug output when set to $true
$DEBUG = $false

# =====================================================================
# PARTICIPATION EXTRACTION FROM README.md
# =====================================================================

function Get-ParticipationGrades {
    <#
        Parses a Markdown table from a Participation file and converts
        emoji-based indicators into LMS rubric level IDs.

        Criteria are driven by the rubric.json config file, so this
        function never contains hardcoded level IDs or criterion IDs.

        Each valid row produces one grading entry keyed by Boréal ID.
    #>
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        # Criteria array loaded from rubric.json
        [Parameter(Mandatory)]
        [object[]]$Criteria,

        # impliedPass rule from rubric.json (optional)
        [object]$ImpliedPass = $null
    )

    $lines = Get-Content $Path
    $results = @()

    foreach ($line in $lines) {

        # Only process Markdown table rows starting with:
        # | <number> |
        if ($line -match '^\|\s*\d+\s*\|') {

            # Split on column separators
            $cols = $line -split '\|'

            # Columns (0 is empty):
            # 1 = index
            # 2 = Boréal ID link column
            # 3+ = grading columns (mapped by criteria[].col)

            # Extract Boréal ID (expected format: [300000000])
            if ($cols[2] -match '\[(\d{9})\]') {
                $borealId = $matches[1]
            } else {
                # Skip malformed rows
                continue
            }

            # Build a result object dynamically from criteria config
            $entry = [ordered]@{ borealId = $borealId }

            foreach ($criterion in $Criteria) {
                $emoji  = ($cols[$criterion.col]).Trim()
                $levels = [int[]]$criterion.levels

                # "comments" criterion: capture raw text, not an emoji score
                if ($criterion.name -eq 'comments') {
                    $entry[$criterion.name] = $emoji
                    continue
                }

                $levelId = Get-RubricLevelId -Emoji $emoji -Levels $levels
                $entry[$criterion.name] = $levelId
            }

            # Apply implied-pass rule (e.g. gold README → images pass)
            if ($ImpliedPass) {
                $whenVal = $entry[$ImpliedPass.when]
                if ($whenVal -gt $ImpliedPass.exceeds) {
                    $entry[$ImpliedPass.set] = $ImpliedPass.levelid
                }
            }

            if ($DEBUG) {
                Write-Output $entry
            }

            $results += [PSCustomObject]$entry
        }
    }

    return $results
}

function New-LMSRubricFromEntry {
    <#
        Builds a rubric payload array from a parsed participation entry
        and the criteria config loaded from rubric.json.

        The resulting array is consumed directly by Send-LMSRubricGrade.
    #>
    param (
        [Parameter(Mandatory)]
        [object]$Entry,

        # Criteria array loaded from rubric.json
        [Parameter(Mandatory)]
        [object[]]$Criteria
    )

    $rubric = foreach ($criterion in $Criteria) {

        # "comments" criterion supplies the remark text, not a levelid
        if ($criterion.name -eq 'comments') { continue }

        $levelId = $Entry.$($criterion.name)

        if (-not $levelId) {
            throw "Invalid levelid for criterion $($criterion.criterionid) ('$($criterion.name)')"
        }

        # Resolve remark: if remark is a field name pointing to entry data, use it
        $remark = if ($Entry.PSObject.Properties.Name -contains $criterion.remark) {
            $Entry.$($criterion.remark)
        } else {
            $criterion.remark
        }

        @{
            criterionid = [int]$criterion.criterionid
            levelid     = [int]$levelId
            remark      = $remark
        }
    }

    return @($rubric)
}
