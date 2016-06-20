function Read-Leaf {
    Param(
        [ValidateScript({Is-ReadLeafMetadata $_})]
        [hashtable]$Metadata,
        [hashtable]$PastResponses = @{}
    )

    if ($Metadata.Guard -and !(& $Metadata.Guard $PastResponses)) {
        return
    }

    $Alias = if ($Metadata.Alias) {$Metadata.Alias} else {$Metadata.Path}
    $Default = if ($Metadata.Default) {& $Metadata.Default $PastResponses}
    $Description = $Metadata.Description
    $Example = $Metadata.Example

    $ColoredAlias = @(@{Value = "$Alias"; Color = "Green"}, "`r`n")
    $ColoredDefault = if ($Default) {
        @("Default: ", @{Value = $Default; Color = "Magenta"})
    }
    $ColoredDescription = @()
    if ($Description) {
        $ColoredDescription += $Description
        if ($Default) {$ColoredDescription += @(" (", $ColoredDefault, ")")}
        $ColoredDescription += "`r`n"
    } elseif ($Default) {
        $ColoredDescription += @($ColoredDefault, "`r`n")
    }
    $ColoredExample = @()
    if ($Example) {
        $ColoredExample += @("For example: ", @{Value = $Example; Color = "Cyan"}, "`r`n")
    }

    $Message = @($ColoredAlias)
    if ($ColoredDescription) {$Message += $ColoredDescription}
    if ($ColoredExample) {$Message += $ColoredExample}

    $Verify = $Metadata.Verify
    $Stop = $Metadata.Stop

    $Responses = @()
    while ($true) {
        Write-Color $Message
        if ($Metadata.Metadata) {
            $Response = Read-Tree $Metadata.Metadata
        } else {
            $Response = (Read-Host).Trim()
        }

        if (!$Response -and $Default) {
            $Response = $Default
        }
        if (!$Verify -or (& $Verify $Response $PastResponses)) {
            $Responses += @($Response)
            if (!$Stop -or (& $Stop $Responses $PastResponses)) {
                break
            }
        }
    }
    if ($Stop) {return $Responses}
    return $Responses[0]
}

function Is-ReadLeafMetadata {
    Param(
        [hashtable]$Metadata
    )

    return $Metadata.ContainsKey("Path")
}