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

Write-Host "Start to call git checkout $BranchName"
git fetch
git checkout $BranchName
Pop-Location