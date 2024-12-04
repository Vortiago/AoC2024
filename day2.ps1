param (
    [string] $inputFile
)

if ("" -eq $inputFile) {
    $inputData = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
}
else {
    $inputData = Get-Content -Raw $inputFile
}

enum Direction {
    None
    Increasing
    Decreasing
}

function DefaultParser($inputText, $split = [System.Environment]::NewLine) {
    $stringSplitOptions = [System.StringSplitOptions]::RemoveEmptyEntries
    return $inputText.Split($split, $stringSplitOptions)
}

function ParseRows($inputText) {
    return DefaultParser($inputText)
}

function ParseReport($row) {
    $levels = $row.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $levels = $levels.ForEach({ [int]$_ })
    return $levels
}

function CheckDirection([int]$left, [int]$right) {
    if ($left -lt $right) {
        return [Direction]::Increasing
    }
    else {
        return [Direction]::Decreasing
    }
}

function CheckDistanse([int]$left, [int]$right) {
    if ([Math]::Abs($right - $left) -in 1..3) {
        return $true
    }

    return $false
}

function CheckReport( [System.Collections.ArrayList]$levels, $dampenerUsesLeft = 1) {
    $direction = CheckDirection $levels[0] $levels[1]

    for ($position = 1; $position -lt $levels.Count; $position++) {
        if ((CheckDirection $levels[$position - 1] $levels[$position]) -eq $direction) {
            if ((CheckDistanse $levels[$position - 1] $levels[$position])) {
                continue
            }
        }

        if ($dampenerUsesLeft -gt 0) {
            $dampenerUsesLeft--

            for ($position = 0; $position -lt $levels.Count; $position++) {
                $modifiedLevels = $levels.Clone()
                $modifiedLevels.RemoveAt($position)
                if (CheckReport $modifiedLevels $dampenerUsesLeft) {
                    return $true
                }
            }
        }

        return $false
    }

    return $true
}

$reports = ParseRows($inputData)
$numOfSafeReports = 0
foreach ($report in $reports) {
    $levels = ParseReport($report)
    $reportState = CheckReport $levels
    $safeText = "Unsafe"
    if ($reportState) {
        $numOfSafeReports++;
        $safeText = "Safe"
    }
    else {

        Write-Output "Report: $report is $safeText"
    }
}

Write-Output "Total safe reports: $numOfSafeReports"