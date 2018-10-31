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
git checkout $BranchName
Pop-Location