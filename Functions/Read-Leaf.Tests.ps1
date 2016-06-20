InModuleScope Read-Tree {
    Describe "the Read-Leaf function" {
        Mock Write-Host {$Script:Output += $Object}
        Context "with no conditions" {
            Mock Read-Host {return "John Doe"}
            It "fails on no path" {
                {Read-Leaf @{}} | Should Throw 
            }
            It "returns response" {
                Read-Leaf @{Path = "User.Name"} | Should Be "John Doe"
            }
            It "writes alias as the first line" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Alias = "Username"}
                $Script:Output | Should Be "Username`r`n"
            }
            It "writes path as first line in place of alias" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"}
                $Script:Output | Should Be "User.Name`r`n"
            }
            It "writes description on second line" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Description = "The username"}
                ($Script:Output -Split "\r\n")[1] | Should Be "The username"
            }
            It "writes default on second line" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Default = {"John Doe"}}
                ($Script:Output -Split "\r\n")[1] | Should Be "Default: John Doe"
            }
            It "writes description + default on second line" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Description = "The username"; Default = {"John Doe"}}
                ($Script:Output -Split "\r\n")[1] | Should Be "The username (Default: John Doe)"
            }
            It "writes example on second line w/o description or default" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Example = "John Doe"}
                ($Script:Output -Split "\r\n")[1] | Should Be "For Example: John Doe"
            }
            It "writes example on third line after description or default" {
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Description = "The username"; Example = "John Doe"}
                ($Script:Output -Split "\r\n")[2] | Should Be "For Example: John Doe"
                $Script:Output = ""
                Read-Leaf @{Path = "User.Name"; Default = {"John Doe"}; Example = "John Doe"}
                ($Script:Output -Split "\r\n")[2] | Should Be "For Example: John Doe"
            }
        }
        Context "with a guard condition" {
            It "returns null on guard false" {
                Read-Leaf @{Path = "User.Name"; Guard = {$false}} | Should Be $null
            }
        }
        Context "with a stop condition" {
            $FavoriteFoods = @("Steak", "Smoothie", "Apple", "Pork Chop")
            Mock Read-Host {
                $Script:ReadIndex++
                return $FavoriteFoods[$Script:ReadIndex]
            }
            It "returns list with stop condition" {
                $Script:ReadIndex = -1
                $Metadata = @{
                    Path = "Food.Favorites"
                    Stop = {Param($Response) $Response -eq "Pork Chop"}
                }
                $Responses = Read-Leaf $Metadata
                0..3 | % {$Responses[$_] | Should Be $FavoriteFoods[$_]}
            }
            It "returns tree-list with stop condition and metadata" {
                $Script:ReadIndex = -1
                $UserResponses = @("John", "john@test.com", "Jane", "jane@test.com")
                Mock Read-Host {
                    $Script:ReadIndex++
                    return $UserResponses[$Script:ReadIndex]
                }
                $Metadata = @{
                    Path = "Users"
                    Metadata = @(@{
                        Path = "Name"
                    }, @{
                        Path = "Email"
                    })
                    Stop = {
                        Param($Responses)
                        $Responses.Length -eq 2
                    }
                }
                $Responses = Read-Leaf $Metadata
                $Responses[0].Name | Should Be "John"
                $Responses[0].Email | Should Be "john@test.com"
                $Responses[1].Name | Should Be "Jane"
                $Responses[1].Email | Should Be "jane@test.com"
            }
        }
        Context "with a verify condition" {
            $NameResponses = @("Jhon Doe", "John Doe")
            Mock Read-Host {
                $Script:ReadIndex++
                return $NameResponses[$Script:ReadIndex]
            }
            It "tries again on failed verification" {
                $Script:ReadIndex = -1
                $Metadata = @{
                    Path = "User.Name"
                    Verify = {Param($Response) $Response -eq "John Doe"}
                }
                Read-Leaf $Metadata | Should Be "John Doe"
                Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
            }
        }
    }
}