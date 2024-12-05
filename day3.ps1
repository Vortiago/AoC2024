param (
    [string] $inputFile
)

if ("" -eq $inputFile) {
    #$inputData = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    $inputData = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
}
else {
    $inputData = Get-Content -Raw $inputFile
}

$part1Pattern = "mul\(\d+,\d+\)"
$multiplicationCommands = [regex]::Matches($inputData, $part1Pattern)

$sum = 0
$digitMatch = "\d+"
foreach($command in $multiplicationCommands) {
    $digits = [regex]::Matches($command, $digitMatch)
    $sum += ([int]$digits[0].Value * [int]$digits[1].Value)
}

Write-Output "Total sum: $sum"

$inputData = "do()$inputData"

$parts = $inputData.Split("don't()")

$part2Sum = 0
foreach ($part in $parts) {
    $eggs = $part.Split('do()')
    $goldenEgg = $eggs[1..$eggs.Count]
    $multiplicationCommands = [regex]::Matches($goldenEgg, $part1Pattern)
    
    foreach($command in $multiplicationCommands) {
        $digits = [regex]::Matches($command, $digitMatch)
        $part2Sum += ([int]$digits[0].Value * [int]$digits[1].Value)
    }
}

Write-Output "Total sum 2: $part2Sum"