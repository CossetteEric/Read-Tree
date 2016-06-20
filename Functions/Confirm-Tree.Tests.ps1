InModuleScope Read-Tree {
    Describe "the Confirm-Tree function" {
        $MockResponses = @("Jhon Doe", "n", "John Doe", "y")
        Mock Read-Host {
            $Script:ResponseIndex++
            return $MockResponses[$Script:ResponseIndex]
        }
        Mock Write-Host {}
        It "tries again on 'n'" {
            $Script:ResponseIndex = -1
            $Metadata = @(@{Path = "Name"})
            Confirm-Tree $Metadata | % {
                $_.Name -eq "John Doe"
            }
        }
    }
}