function Mock-Function1 {
    <#
    .SYNOPSIS
    A synopsis of Mock-Function1.

    .DESCRIPTION
    A description of the function.

    .EXAMPLE
    Mock-Function1

    .INPUTS
    None

    .OUTPUTS
    None

    .NOTES
    None
    #>

    [CmdletBinding()]
    param()

    'Welcome to Mock-Function1' | Write-Host
    Private-Function1
}
