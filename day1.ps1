param (
    [string] $inputFile
)

if ("" -eq $inputFile) {
    $dayInput = "3   4
4   3
2   5
1   3
3   9
3   3"
} else {
    $dayInput = Get-Content -Raw $inputFile
}

function DefaultParser($inputText, $split = [System.Environment]::NewLine) {
    $stringSplitOptions = [System.StringSplitOptions]::RemoveEmptyEntries
    return $inputText.Split($split, $stringSplitOptions)
}

$rows = DefaultParser($dayInput)

$leftList = New-Object System.Collections.Generic.List[int]
$rightList = New-Object System.Collections.Generic.List[int]

foreach ($row in $rows) {
    $values = DefaultParser $row "   "
    $leftList.Add([int]$values[0])
    $rightList.Add([int]$values[1])
}

$leftList.Sort()
$rightList.Sort()

$total = 0

for ($x = 0; $x -le $leftList.Count; $x++) {
    $total += [Math]::Abs($rightList[$x] - $leftList[$x])
}

Write-Output "Day 1, Part 1: " $total

$similarityCount = @{}
$similarityValue = @{}

for ($x = 0; $x -le $leftList.Count; $x++) {
    $numToCheck = $leftList[$x]
    if ($null -eq $similarityCount[$numToCheck]) {
        $similarityValue[$numToCheck] = $rightList.Where({ $_ -eq $numToCheck }).Count * $numToCheck
        $similarityCount[$numToCheck] = 1
    } else {
        $similarityCount[$numToCheck] += 1
    }
}

$totalP2 = 0

foreach ($row in $similarityCount.Keys) {
    $totalP2 += ($similarityCount[$row] * $similarityValue[$row])
}

Write-Output $totalP2