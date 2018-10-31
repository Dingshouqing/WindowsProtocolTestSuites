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
    "git fetch" | Out-File checkoutbranch.cmd
    Add-Content -Path checkoutbranch.cmd -Value "git checkout $BranchName"
    Write-Host "Execute checkout branch"
    $batch = Start-Process -FilePath .\checkoutbranch.cmd -Wait -passthru
    Write-Host ("Exit code:" + $batch.ExitCode)
    Remove-Item .\checkoutbranch.cmd
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