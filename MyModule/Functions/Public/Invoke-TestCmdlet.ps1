function Invoke-TestCmdlet
{
    <#
    .SYNOPSIS
        Invokes the sample cmdlet.

    .DESCRIPTION
        Invokes the sample cmdlet.

    .PARAMETER Name
        The name parameter

    .EXAMPLE
        PS C:\> Invoke-TestCmdlet -Name 'Test'
        Invokes the sample cmdlet.
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        $Name
    )
    Process
    {
        Write-Output "Hello $Name"
    }
}