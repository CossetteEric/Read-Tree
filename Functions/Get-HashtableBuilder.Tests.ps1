InModuleScope Read-Tree {
    Describe "the Get-HashtableBuilder function" {
        It "adds depth one" {
            $User = @{}
            & (Get-HashtableBuilder "User" "Name")
            $User.Keys.Count | Should Be 0
        }
        It "adds depth two" {
            $Config = @{}
            & (Get-HashtableBuilder "Config" "User.Name")
            $Config.User -is [hashtable] | Should Be $true
        }
        It "adds depth three" {
            $System = @{}
            & (Get-HashtableBuilder "System" "Config.User.Name")
            $System.Config.User -is [hashtable] | Should Be $true
        }
    }
}