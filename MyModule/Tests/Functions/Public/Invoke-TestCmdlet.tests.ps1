Import-Module MyModule

Describe 'TestCmdlet' {
    It 'Returns an output string' {
        Invoke-TestCmdlet -Name 'Example' | Should Be "Hello Example"
    }
}