function Get-HashtableBuilder {
<#
.SYNOPSIS
Creates a scriptblock that will build out the tree so you can safely assign
a value to the leaf-node of the path.

.PARAMETER TableName
The name of the hashtable variable without a $-prefix

.PARAMETER Path
The path through the tree with each node separated by a dot (.)

.EXAMPLE
$System = @{}
& (Get-HashtableBuilder "System" "Config.User.Name")
$System.Config.User.Name = "John"
#>
    Param(
        [string]$TableName,
        [string]$Path
    )
    
    $Nodes = $Path.Split(".")
    $basecase = "if (!(`$$TableName -is [hashtable])) {`$$TableName = @{}}"

    $Branches = if ($Nodes.Length -gt 1) {$Nodes[0..($Nodes.Length - 2)]}
    $Lines = if ($Branches) {$Branches | % {$TreePath = $TableName} {
        $TreePath += ".$_"
        "if (!`$$TreePath) {`$$TreePath = @{}}"
    }}
    $BuildString = (@($basecase) + $Lines) -Join [System.Environment]::NewLine
    return [scriptblock]::Create($BuildString)
}