$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$here\..\Read-Tree.psm1"

$Metadata = @(@{
    Path = "Config.User.FullName"
    Alias = "Full Name"
    Example = "John Doe"
}, @{
    Path = "Config.User.Website"
    Alias = "Website"
    Example = "test.com"
}, @{
    Path = "Config.User.Email"
    Alias = "Email Address"
    Default = {
        Param([hashtable]$Responses)
        $leftPart = $Responses.Config.User.FullName.Replace(" ", ".").ToLower()
        $rightPart = $Responses.Config.User.Website
        return "$leftPart@$rightPart"
    }
}, @{
    Path = "Config.User.UserName"
    Alias = "User Name"
    Default = {
        Param([hashtable]$Responses)
        $Responses.Config.User.FullName.Replace(" ", ".").ToLower()
    }
})

Confirm-Responses $Metadata