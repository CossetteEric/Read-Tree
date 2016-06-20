InModuleScope Read-Tree {
    Describe "the Write-Color function" {
        Mock Write-Host {}
        It "string writes once" {
            $Message = "Hello world!"
            Write-Color $Message
            Assert-MockCalled "Write-Host" -Exactly 1 -Scope It
        }
        It "list writs n times" {
            $Message = @("Hello", "World", "!")
            Write-Color $Message
            Assert-MockCalled "Write-Host" -Exactly 3 -Scope It
        }
        It "writes tree" {
            $HostResults = @()
            Write-Color @{Value = @("Hello", " ", @{Value = "World!"; Color = "Red"})}
            Assert-MockCalled "Write-Host" -Exactly 3 -Scope It
        }
    }
    Describe "the Is-ColorText function" {
        It "returns false on null" {
            Is-ColorText $null | Should Be $false
        }
        It "returns true on string" {
            Is-ColorText "Hello world!" | Should Be $true
        }
        It "returns true on hashtable with Value property" {
            Is-ColorText @{Value = "Hello world!"} | Should Be $true
            Is-ColorText @{Value = "Hello world!"; Color = "blue"} | Should Be $true
        }
        It "returns false on hashtable without Value property" {
            Is-ColorText @{} | Should Be $false
            Is-ColorText @{Color = "Red"} | Should Be $false
        }
        It "returns true on string array" {
            Is-ColorText @("Hello", " ", "world", "!") | Should Be $true
        }
        It "returns true on valid hashtable array" {
            Is-ColorText @(@{Value = "Hello"; Color = "blue"}, @{Value = " "}, @{Value = "world"; Color = "green"}, @{Value = "!"}) | Should Be $true
        }
        It "returns true on valid string/hashtable array" {
            Is-ColorText @(@{Value = "Hello"; Color = "blue"}, " ", @{Value = "world"; Color = "green"}, "!") | Should Be $true
        }
    }
}