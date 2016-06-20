function Get-HashtableAssigner {
    Param(
        [string]$HashtableName,
        [string]$Path
    )

    [scriptblock]::Create("Param(`$Value) `$$HashtableName.$Path = `$Value")
}