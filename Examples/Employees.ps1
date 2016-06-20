$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$here\..\Read-Tree.psm1"

$Metadata = @(@{
    Path = "Total"
    Alias = "Total Employees"
    Verify = {
        Param([string]$Response)
        if (!$Response -Match "0*[1-9]+[0-9]*") {
            Write-Host "Must be an integer greater than 0"
            return $false
        }
        return $true
    }
}, @{
    Path = "Employees"
    Metadata = @(@{
        Path = "Name"
    }, @{
        Path = "Email"
    })
    Stop = {
        Param([string[]]$Responses, [hashtable]$Tree)
        return $Responses.Length -eq $Tree.Total
    }
})

$EmployeeData = Read-Tree $Metadata
$EmployeeData
