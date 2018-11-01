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

    "git fetch" | Out-File "$path\checkoutbranch.cmd" -Encoding utf8    ## fetch all repo
    Add-Content -Path "$path\checkoutbranch.cmd" -Value "git checkout $BranchName" -Encoding utf8   ## checkout specified branch
    Add-Content -Path "$path\checkoutbranch.cmd" -Value "git pull origin $BranchName" -Encoding utf8    ## pull latest changes.

    Write-Host "Execute checkout branch"
    $batch = Start-Process -FilePath "$path\checkoutbranch.cmd" -Wait -passthru
    Write-Host ("Exit code:" + $batch.ExitCode)
    Remove-Item "$path\checkoutbranch.cmd"
}
catch {
    Write-Warning $_.Exception.Message
}

$branch = &git rev-parse --abbrev-ref HEAD
Write-Host "Current Branch: $branch" -ForegroundColor Yellow
if ($branch -ne $BranchName) {
    $LastExitCode = 1
    throw "Check out branch $BranchName failed"
}
else {
    $LastExitCode = 0
}
## Merge Helper branch to TestSuites Branch

$currentDir = split-path -parent $MyInvocation.MyCommand.Definition | Select-Object -first 1
Write-Host "Current Helper Repo Folder: $currentDir"

$testSuitePath = split-path $currentDir
Write-Host "Current TestSuite Repo Folder: $testSuitePath"

$toMerge = @('ProtoSDK', 'TestSuites', "AzureScripts")
$azureScriptPath = (Join-Path $currentDir "AzureScripts")
if ( Test-Path -Path $azureScriptPath) {
    Write-Host "AzureScript folder already exists, file will be override by Helper branch"
}
else {
    New-Item -ItemType Directory -Path $azureScriptPath
}
$toMerge | Copy-Item -Path {Join-Path $currentDir $_} -Dest $testSuitePath -Recurse -Force

Pop-Location

