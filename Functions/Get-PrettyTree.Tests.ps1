InModuleScope Read-Tree {
    Describe "the Get-PrettyTree function" {
        Context "string value" {
            It "prettifies depth of 1" {
                Get-PrettyTree @{Name = "John Doe"} | Should Be "Name = John Doe"
            }
            It "prettifies depth of 2" {
                Get-PrettyTree @{User = @{Name = "John Doe"}} | Should Be @"
User
|-Name = John Doe
"@
            }
            It "prettifies depth of 3" {
                Get-PrettyTree @{Config = @{User = @{Name = "John Doe"}}} | Should Be @"
Config
|-User
|--Name = John Doe
"@
            }
        }
        Context "list value" {
            It "prettifies depth of 1" {
                Get-PrettyTree @{Names = @("John", "Jane")} | Should Be @"
Names = John, Jane
"@
            }
            It "prettifies depth of 2" {
                Get-PrettyTree @{User = @{Names = @("John", "Jane")}} | Should Be @"
User
|-Names = John, Jane
"@
            }
            It "prettifies depth of 3" {
                Get-PrettyTree @{Config = @{User = @{Names = @("John", "Jane")}}} | Should Be @"
Config
|-User
|--Names = John, Jane
"@
            }
        }
        Context "mixed values" {
            It "prettifies depth of 1" {
                $Tree = @{
                    Total = "2"
                    Names = @("John", "Jane")
                }
                Get-PrettyTree $Tree | Should Be @"
Total = 2
Names = John, Jane
"@
            }
        }
    }
}