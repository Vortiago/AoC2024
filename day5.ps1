param (
    [string] $inputFile
)

if ("" -eq $inputFile) {
    $inputData = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"
}
else {
    $inputData = Get-Content -Raw $inputFile
}

Write-Output ""

$rules = $inputData.Split([System.Environment]::NewLine + [System.Environment]::NewLine)[0].Split([System.Environment]::NewLine)
$pageOrders = $inputData.Split([System.Environment]::NewLine + [System.Environment]::NewLine)[1].Split([System.Environment]::NewLine)

function CheckRules($pageOrder) {
    foreach ($rule in $rules) {
        $rulePages = $rule.Split("|")
        if ($pageOrder.Contains($rulePages[0]) -and $pageOrder.Contains($rulePages[1])) {
            if ([regex]::Matches($pageOrder, "$($rulePages[0]).*$($rulePages[1])").Success -ne $true) {
                return $false
            }
        }
    }

    return $true

}

$sum = 0
$invalidPages = @()
foreach ($pageOrder in $pageOrders) {
    $result = CheckRules $pageOrder
    if ($result -eq $true) {
        $pages = $pageOrder.Split(",")
        $sum += [int]($pages[($pages.Length - 1) / 2])
    } else {
        $invalidPages += $pageOrder
    }
    Write-Output "$pageOrder is sorted: $result" 
}

Write-Output "Sum of middle pages: $sum"

function SortOrder($localRules) {
    $graph = @{};
    $inDegree = @{}
    
    foreach($rule in $localRules) {
        $before, $after = $rule.Split('|')

        if(!$graph[$before]) { 
            $graph[$before] = @() 
        }

        $graph[$before] += $after
        
        if(!$inDegree[$before]) {
            $inDegree[$before] = 0 
        }

        $inDegree[$after] = ($inDegree[$after] ?? 0) + 1
    }
    
    $queue = $inDegree.Keys.Where({$inDegree[$_] -eq 0})
    $result = @()
    
    while($queue) {
        $node, $queue = $queue[0], $queue[1..$queue.Length]
        $result += $node
        $graph[$node] | Where-Object {$_} | ForEach-Object { 
            if(--$inDegree[$_] -eq 0) { $queue += $_ }
        }
    }
    
    if($result.Count -eq $inDegree.Count) { $result } else { $null }
}

$sumInvalidPages = 0
foreach ($pageOrder in $invalidPages) {
    $precisionRules = $rules.Where({ $pageOrder.Contains($_.Split("|")[0]) -and $pageOrder.Contains($_.Split("|")[1]) })
    $result = (SortOrder $precisionRules).Where({$pageOrder.Split(",").Contains($_)})
    Write-Host "From: $pageOrder to $($result -join ",")"
    $sumInvalidPages += $result[($result.Count -1 ) / 2]
}

Write-Output "Sum of Invalid Pages: $sumInvalidPages"