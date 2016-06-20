function Get-PrettyTree {
    Param(
        [hashtable]$Tree,
        [int]$Depth = 0
    )

    $String = ""
    $Tree.GetEnumerator() | % {
        if ($Depth -gt 0) {
            $String += "|"
        }
        $String += "-" * $Depth
        if ($_.Value -is [hashtable]) {
            $String += "$($_.Key)`r`n$(Get-PrettyTree $_.Value ($Depth + 1))"
        } elseif ($_.Value -is [Array]) {
            $String += "$($_.Key) = $($_.Value -Join ", ")"
        } else {
            $String += "$($_.Key) = $($_.Value)"
        }
        $String += "`r`n"
    }
    return $String.Substring(0, [Math]::max($String.Length - 2, 0))
}
