<#
.SYNOPSIS
    Invokes the unit tests pipeline step.

.DESCRIPTION
    Invokes the unit tests pipeline step.

.PARAMETER ModulePath
    Provide the directory path where the module resides.

.PARAMETER PesterVersion
    Provide the Pester module version number to use.

.PARAMETER TestResultsFilePath
    Provide the file path where the test results should be written to.

.EXAMPLE
    PS C:\> .\Invoke-UnitTestsStep.ps1 -ModulePath <path> -PesterVersion 4.10.1 -TestResultsFilePath <path-to-file>
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
        HelpMessage="Provide the Pester module version number to use.")]
    [System.String]
    $PesterVersion,

    [Parameter(
        Mandatory=$true,
        HelpMessage="Provide the file path where the test results should be written to.")]
    [System.String]
    $TestResultsFilePath
)

Write-Host "Running build pipeline step: Unit tests"

Write-Host "Checking if the Pester module is already installed."

$modulePrerequisite = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Pester" -and $_.Version -eq $PesterVersion }

if ($modulePrerequisite -eq $null)
{
    Write-Host "Module is missing. Installing it now."
    Install-Module -Name "Pester" -Force -Scope CurrentUser -RequiredVersion $PesterVersion
}
else
{
    Write-Host "Module is already installed, no action taken."
}

Write-Host "Adding temporary PSModulePath update to allow module loading by name."
$env:PSModulePath = (Get-Item $ModulePath).Parent.FullName + $([System.IO.Path]::PathSeparator) + $env:PSModulePath

Write-Host "Invoking the unit tests with Pester."

$results = Invoke-Pester -Script $ModulePath -OutputFile $TestResultsFilePath -OutputFormat NUnitXml -PassThru

$failedTests = $results.TestResult | Where-Object { $_.Result -eq 'Failed' }

if ($failedTests -eq $null)
{
    Write-Host "Pester unit test run has completed. No test failures were detected."
}
else
{
    throw "Pester unit test run has completed. Detected $($failedTests.Count) total test failure(s). See log for full details."
}
