param (
    [string] $inputFile
)

if ("" -eq $inputFile) {
    $inputData = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"
}
else {
    $inputData = Get-Content -Raw $inputFile
}

$charMap = $inputData.Split([System.Environment]::NewLine) | ForEach-Object { , [char[]]$_}

class Direction {
    [int] $RowDirection
    [int] $ColumnDirection

    Direction($rowDirection, $columnDirection) {
        $this.RowDirection = $rowDirection
        $this.ColumnDirection = $columnDirection
    }
}

$NorthDirection = [Direction]::new(-1, 0)
$NorthEastDirection = [Direction]::new(-1, 1)
$EastDirection = [Direction]::new(0, 1)
$SouthEastDirection = [Direction]::new(1, 1)
$SouthDirection = [Direction]::new(1, 0)
$SouthWestDirection = [Direction]::new(1, -1)
$WestDirection = [Direction]::new(0, -1)
$NorthWestDirection = [Direction]::new(-1, -1)

function Get-2DArrayElement {
    param(
        [array]$Array,
        [int]$RowIndex,
        [int]$ColumnIndex
    )
    if ($RowIndex -lt 0 -or $RowIndex -ge $Array.Length) {
        throw [System.IndexOutOfRangeException]::new("")
    }
    if ($ColumnIndex -lt 0 -or $ColumnIndex -ge $Array[$RowIndex].Length) {
        throw [System.IndexOutOfRangeException]::new("")
    }
    return $Array[$RowIndex][$ColumnIndex]
}

function CheckDirection([Direction]$direction, $row, $column) {
    try {
        if ((Get-2DArrayElement $charMap ($row + $direction.RowDirection) ($column + $direction.ColumnDirection)) -eq "M" -and
            (Get-2DArrayElement $charMap ($row + ($direction.RowDirection * 2)) ($column + ($direction.ColumnDirection * 2))) -eq "A" -and 
            (Get-2DArrayElement $charMap ($row + ($direction.RowDirection * 3)) ($column + ($direction.ColumnDirection * 3))) -eq "S") {
            return 1
        }
    } catch { }

    return 0
}

function ExplodeChar($row, $column) {
    $foundXMAS = 0
    $foundXMAS += (CheckDirection $NorthDirection $row $column)
    $foundXMAS += (CheckDirection $NorthEastDirection $row $column)
    $foundXMAS += (CheckDirection $EastDirection $row $column)
    $foundXMAS += (CheckDirection $SouthEastDirection $row $column)
    $foundXMAS += (CheckDirection $SouthDirection $row $column)
    $foundXMAS += (CheckDirection $SouthWestDirection $row $column)
    $foundXMAS += (CheckDirection $WestDirection $row $column)
    $foundXMAS += (CheckDirection $NorthWestDirection $row $column)

    return $foundXMAS
}

$numberOfXMASs = 0
for ($row = 0; $row -lt $charMap.Count; $row++) {
    for ($column = 0; $column -lt $charMap[$row].Count; $column++) {
        if ($charMap[$row][$column] -eq "X") {
            $numFounds = ExplodeChar $row $column
            $numberOfXMASs += $numFounds
        }
    }
}

Write-Output "XMASs: " $numberOfXMASs

function ExplodeCharMAS($row, $column) {
    $foundMAS = 0

    try {
        if ((Get-2DArrayElement $charMap ($row + 1) ($column + 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row - 1) ($column - 1)) -eq "S") {
            $foundMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row + 1) ($column - 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row - 1) ($column + 1)) -eq "S") {
            $foundMAS++
        }
    } catch {}
    try {        
        if ((Get-2DArrayElement $charMap ($row - 1) ($column - 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row + 1) ($column + 1)) -eq "S") {
            $foundMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row - 1) ($column + 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row + 1) ($column - 1)) -eq "S") {
            $foundMAS++
        }
    } catch {}
    if ($foundMAS -gt 1) {
        return $true
    }
    return $false
}

$numberOfMASs = 0
for ($row = 0; $row -lt $charMap.Count; $row++) {
    for ($column = 0; $column -lt $charMap[$row].Count; $column++) {
        if ($charMap[$row][$column] -eq "A") {
            if (ExplodeCharMAS $row $column) {
                $numberOfMASs += 1
            }
        }
    }
}

Write-Output "MASs: " $numberOfMASs