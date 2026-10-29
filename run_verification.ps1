param([string]$Matlab = 'matlab', [string]$LicenseFile = '', [switch]$Full)
$ErrorActionPreference = 'Stop'
Push-Location -LiteralPath $PSScriptRoot
try {
    function Invoke-Checked([string]$Program, [string[]]$Parameters) {
        & $Program @Parameters
        if ($LASTEXITCODE -ne 0) { throw "$Program failed with exit code $LASTEXITCODE" }
    }
    Invoke-Checked 'node' @('Secure Communication Smart Contract/compile.cjs')
    Invoke-Checked 'python' @('verification/verify_policy.py')
    Invoke-Checked 'node' @('Secure Communication Smart Contract/verify_contract.cjs')
    Invoke-Checked 'node' @('Secure Communication Smart Contract/test_workflow.cjs')
    Invoke-Checked 'python' @('verification/verify_chainxim.py')
    if ($Full) {
        Invoke-Checked 'python' @('verification/r26/evaluate_ap26.py','verification/results/r26_policy')
        $modelDirectory = (Join-Path $PSScriptRoot 'Matlab Simulation/Revision_R3').Replace("'", "''")
        $matlabArguments = @()
        if ($LicenseFile) { $matlabArguments += @('-c',$LicenseFile) }
        $matlabArguments += @('-batch',"cd('$modelDirectory'); run_revision_suite;")
        Invoke-Checked $Matlab $matlabArguments
        Invoke-Checked 'python' @('verification/verify_matlab.py')
        Invoke-Checked 'python' @('verification/verify_service_traces.py')
        Invoke-Checked 'python' @('Matlab Simulation/Revision_R3/plot_revision.py')
    }
} finally { Pop-Location }
