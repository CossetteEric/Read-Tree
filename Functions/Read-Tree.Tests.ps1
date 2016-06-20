InModuleScope Read-Tree {
    Describe "the Read-Tree function" {
        Mock Write-Host {}
        Mock Read-Host {return "John Doe"}
        It "creates tree of depth one" {
            $Metadata = @(@{Path = "Name"})
            Read-Tree $Metadata | % {
                $_.Name | Should Be "John Doe"
            }
        }
        It "creates tree of depth two" {
            $Metadata = @(@{Path = "User.Name"})
            Read-Tree $Metadata | % {
                $_.User | % {
                    $_.Name | Should Be "John Doe"
                }
            }
        }
        It "creates tree of depth three" {
            $Metadata = @(@{Path = "Config.User.Name"})
            Read-Tree $Metadata | % {
                $_.Config | % {
                    $_.User | % {
                        $_.Name | Should Be "John Doe"
                    }
                }
            }
        }
        It "creates a tree with a tree list" {
            $Script:ReadIndex = -1
            $UserResponses = @("2", "John", "john@test.com", "Jane", "jane@test.com")
            Mock Read-Host {
                $Script:ReadIndex++
                return $UserResponses[$Script:ReadIndex]
            }
            $Metadata = @(@{
                Path = "Config.TotalUsers"
                Convert = {
                    return [int]$Response
                }
            }, @{
                Path = "Config.Users"
                Metadata = @(@{
                    Path = "Name"
                }, @{
                    Path = "Email"
                })
                Stop = {
                    Param($Responses, $PastResponses)
                    $Responses.Length -eq $PastResponses.Config.TotalUsers
                }
            })
            $Tree = Read-Tree $Metadata
            $Tree.Config.TotalUsers | Should Be 2
        }
    }
}