InModuleScope Read-Tree {
    Describe "the Get-HashtableAssigner function" {
        $UserName = "John"

        It "assignes to depth one" {
            $Config = @{User = @{}}
            & (Get-HashtableAssigner "Config" "User.Name") $UserName
            $Config.User.Name | Should Be $UserName
        }
        It "assignes to depth two" {
            $System = @{Config = @{User = @{}}}
            & (Get-HashtableAssigner "System" "Config.User.Name") $UserName
            $System.Config.User.Name | Should Be $UserName
        }
    }
}