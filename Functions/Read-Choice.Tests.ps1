InModuleScope Read-Tree {
    Describe "the Read-YesOrNo function" {
        Mock Write-Host {} # Swallow all output
        It "returns correct answer on valid input" {
            Mock Read-Host {return "y"}
            Read-YesOrNo "This is a test?" | Should Be 'y'
            Mock Read-Host {return "n"}
            Read-YesOrNo "This is a test?" | Should Be 'n'
        }
        It "returns default answer on empty input" {
            Mock Read-Host {return ""}
            Read-YesOrNo "This is a test?" | Should Be 'y'
            Read-YesOrNo "This is a test?" 'n' | Should Be 'n'
        }
        It "returns correct answer on start-of-string match" {
            Mock Read-Host {return "yesterday"}
            Read-YesOrNo "This is a test?" | Should Be 'y'
            Mock Read-Host {return "noir"}
            Read-YesOrNo "This is a test?" | Should Be 'n'
        }
        It "asks again on invalid response" {
            $Script:Index = -1
            $Responses = @("a", "y")
            Mock Read-Host {$Script:Index++; return $Responses[$Script:Index]}
            Read-YesOrNo "This is a test?" | Should Be 'y'
            Assert-MockCalled "Write-Host" -Exactly 3 -Scope It
        }
    }
}