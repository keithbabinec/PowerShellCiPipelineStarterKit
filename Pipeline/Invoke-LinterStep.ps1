<#
.SYNOPSIS
    Invokes the linter pipeline step.

.DESCRIPTION
    Invokes the linter pipeline step.

.PARAMETER ModulePath
    Provide the directory path where the module resides.

.PARAMETER LinterSettingsPath
    Provide the file path for the linter settings file.

.EXAMPLE
    PS C:\> .\Invoke-LinterStep.ps1 -ModulePath <path> -PSScriptAnalyzerVersion 1.19.0 -LinterSettingsPath <path-to-settings-file>
    Invokes the pipeline step.
#>
[CmdletBinding()]
Param
(
    [Parameter(
        Mandatory=$true,
        HelpMessage="Provide the directory path where the module resides.")]
    [System.String]
    $ModulePath,

    [Parameter(
        Mandatory=$true,
        HelpMessage="Provide the module version to use for PSScriptAnalyzer.")]
    [System.String]
    $AnalyzerVersion,

    [Parameter(
        Mandatory=$true,
        HelpMessage="Provide the file path for the linter settings file.")]
    [System.String]
    $LinterSettingsPath
)

Write-Host "Running build pipeline step: Linter"

Write-Host "Checking if the PSScriptAnalyzer module is already installed."

$modulePrerequisite = Get-Module -ListAvailable | Where-Object { $_.Name -eq "PSScriptAnalyzer" -and $_.Version -eq $AnalyzerVersion }

if ($modulePrerequisite -eq $null)
{
    Write-Host "Module is missing. Installing it now."
    Install-Module -Name "PSScriptAnalyzer" -Force -Scope CurrentUser -RequiredVersion $PSScriptAnalyzerVersion
}
else
{
    Write-Host "Module is already installed, no action taken."
}

Write-Host "Invoking the PSScriptAnalyzer linting checks."

$results = Invoke-ScriptAnalyzer -Path $ModulePath -Settings $LinterSettingsPath -Recurse

if ($results -eq $null)
{
    Write-Host "PSScriptAnalyzer linting has completed. No style issues were detected."
}
else
{
    Write-Output $results

    throw "PSScriptAnalyzer linting has completed. Detected $($results.Count) total issue(s). See log for full details."
}
