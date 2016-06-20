function Write-Color {
<#
.SYNOPSIS
Writes text to the host environment in the specified color

.PARAMETER Text
A string or a hashtable, or a list of strings and hashtables

.EXAMPLE
# Write "Hello world!" in the default color.
Write-Color "Hello world!"

.EXAMPLE
# Write "Hello world!" in red.
Write-Color @{Value = "Hello world!"; Color = "Red"}

.EXAMPLE
# Write "Hello" in yellow, "world" in red and "!"" in the default color.
Write-Color @(@{value = 'Hello'; color = 'Blue'}, ' ', @{value = 'world'; color = 'Red'}, '!')

#>
    
    Param(
        [ValidateScript({Is-ColorText $_})]
        [object]$Text
    )
    
    switch ($Text.GetType().Name) {
        "String" {
            Write-Host $Text -NoNewLine
        }
        "Hashtable" {
            if ($Text.Color) {
                Write-Host $Text.Value -Foreground $Text.Color -NoNewLine
            } else {
                Write-Color $Text.Value
            }
        }
        "Object[]" {
            foreach ($t in $Text) {
                Write-Color $t
            }
        }
    }
}

function Is-ColorText {
<#
.SYNOPSIS
Confirm that the specified value is a valid color-text object.

.PARAMETER Text
The object to test
#>
    Param(
        [object]$Text
    )
    
    if (!$Text) {
        return $false
    }
    
    switch ($Text.GetType().Name) {
        "String" {
            return $true
        }
        "Hashtable" {
            if ($Text.Value) {
                return Is-ColorText $Text.Value
            }
        }
        "Object[]" {
            foreach ($t in $Text) {
                if (!(Is-ColorText $t)) {
                    return $false
                } 
            }
            return $true
        }
    }
    return $false
}