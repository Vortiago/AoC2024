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

function ExplodeChar($row, $column) {
    $foundXMAS = 0

    try {
        if ((Get-2DArrayElement $charMap $row ($column + 1)) -eq "M" -and (Get-2DArrayElement $charMap $row ($column + 2)) -eq "A" -and (Get-2DArrayElement $charMap $row ($column + 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap $row ($column - 1)) -eq "M" -and (Get-2DArrayElement $charMap $row ($column - 2)) -eq "A" -and (Get-2DArrayElement $charMap $row ($column - 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {        
        if ((Get-2DArrayElement $charMap ($row + 1) $column) -eq "M" -and (Get-2DArrayElement $charMap ($row + 2) $column) -eq "A" -and (Get-2DArrayElement $charMap ($row + 3) $column) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row - 1) $column) -eq "M" -and (Get-2DArrayElement $charMap ($row - 2) $column) -eq "A" -and (Get-2DArrayElement $charMap ($row - 3) $column) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row + 1) ($column + 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row + 2) $($column + 2)) -eq "A" -and (Get-2DArrayElement $charMap ($row + 3) $($column + 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row + 1) ($column - 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row + 2) $($column - 2)) -eq "A" -and (Get-2DArrayElement $charMap ($row + 3) $($column - 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row - 1) ($column + 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row - 2) $($column + 2)) -eq "A" -and (Get-2DArrayElement $charMap ($row - 3) $($column + 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}
    try {
        if ((Get-2DArrayElement $charMap ($row - 1) ($column - 1)) -eq "M" -and (Get-2DArrayElement $charMap ($row - 2) $($column - 2)) -eq "A" -and (Get-2DArrayElement $charMap ($row - 3) $($column - 3)) -eq "S") {
            $foundXMAS++
        }
    } catch {}

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