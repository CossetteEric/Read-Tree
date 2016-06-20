function Read-YesOrNo {
<#
.SYNOPSIS
Reads either 'y' or 'n' from the user.
#>
    Param(
        [string]$Message,
        [char]$Default = 'y'
    )

    return Read-Character $Message @('y', 'n') $Default
}

function Read-Character {
    Param(
        [string]$Message,
        [char[]]$Choices,
        [char]$Default
    )
    $StrDefault = $Default.ToString()
    $StrChoices = $Choices | % {$_.ToString().ToLower()} | % {
        if ($_ -eq $StrDefault.ToLower()) {$_.ToUpper()} else {$_}
    }
    $ShowChoices = {
        Param([string[]]$Choices)
        Write-Host "$Message [$($Choices -Join "/")]"
    }
    $MatchCondition = {
        Param([string]$Response, [string]$Choice)
        return $Response.ToLower().StartsWith($Choice.ToLower())
    }
    [char](Read-Choice $StrChoices $StrDefault $ShowChoices $MatchCondition)
}

function Read-Choice {
    Param(
        [string[]]$Choices,
        [string]$Default,
        [scriptblock]$ShowChoices,
        [scriptblock]$MatchCondition = {
            Param([string]$Response, [string]$Choice)
            return [string]::Compare($Response, $Choice) -eq 0
        },
        [scriptblock]$ShowErrors = {
            param([string]$Response)
            Write-Host "`"$Response`" does not match any of the available choices."
        }
    )

    do {
        & $ShowChoices $Choices
        $Response = (Read-Host).Trim()

        $Choice =
        if (!$Response) {
            $Default
        } else {
            @($Choices | ? {& $MatchCondition $Response $_})[0]
        }
        if (!$Choice) {
            & $ShowErrors $Response
        }
    } while (!$Choice)
    return $Choice
}