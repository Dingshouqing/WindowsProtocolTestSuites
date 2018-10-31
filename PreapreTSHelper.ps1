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
    Write-Host "Start to call git checkout $BranchName"
    git fetch
    git checkout $BranchName    
}
catch {
    Write-Warning $_.Exception.Message
}

$branch= &git rev-parse --abbrev-ref HEAD

Pop-Location

if($branch -ne $BranchName)
{
    throw "Check out branch $BranchName failed"
}
