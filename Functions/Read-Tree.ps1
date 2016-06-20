function Read-Tree {
    Param(
        [hashtable[]]$Metadata,
        [hashtable]$PastResponses = @{}
    )

    $Responses = $PastResponses
    $Metadata | % {
        & (Get-HashtableBuilder "Responses" $_.Path)

        $Response = Read-Leaf $_ $Responses

        if ($Response) {
            & (Get-HashtableAssigner "Responses" $_.Path) $Response
        }
    }
    return $Responses
}