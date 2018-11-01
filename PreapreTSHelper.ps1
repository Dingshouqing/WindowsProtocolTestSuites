#############################################################################
## Copyright (c) Microsoft Corporation. All rights reserved.
#############################################################################

Param(
    [string]$BranchName = "v-wedin/AddAzureScript"
)

$scriptsPath = Split-Path $MyInvocation.MyCommand.Definition
Push-Location $scriptsPath
Write-Host $scriptsPath
Set-Location .\TSHelper

$path = Get-Location
Write-Host "Current Directory changed to: $path"

try {
    # Write-Host "Start to call git checkout $BranchName"
    # & "git fetch"
    # & "git checkout $BranchName"

    "git fetch" | Out-File "$path\checkoutbranch.cmd" -Encoding utf8
    Add-Content -Path "$path\checkoutbranch.cmd" -Value "git checkout $BranchName" -Encoding utf8
    Write-Host "Execute checkout branch"
    $batch = Start-Process -FilePath "$path\checkoutbranch.cmd" -Wait -passthru
    Write-Host ("Exit code:" + $batch.ExitCode)
    Remove-Item "$path\checkoutbranch.cmd"
}
catch {
    Write-Warning $_.Exception.Message
}

$branch= &git rev-parse --abbrev-ref HEAD

Pop-Location

if($branch -ne $BranchName)
{
    $LastExitCode = 1
    throw "Check out branch $BranchName failed"
}
else{
    $LastExitCode = 0
}