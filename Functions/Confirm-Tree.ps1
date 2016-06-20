function Confirm-Tree {
    Param(
        [hashtable[]]$Metadata,
        [hashtable]$PastResponses = @{}
    )

    $ReadYesOrNo = {(Read-YesOrNo "Are the above responses correct?") -eq 'y'}
    do {
        $Tree = Read-Tree $Metadata $PastResponses
        Write-Host
        Write-Color @(@{Value = "Responses:"; Color = "Red"}, "`r`n")
        Write-Host (Get-PrettyTree $Tree)
        Write-Host
    } while (!(& $ReadYesOrNo))
    return $Tree
}