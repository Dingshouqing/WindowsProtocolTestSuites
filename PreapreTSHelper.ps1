#############################################################################
## Copyright (c) Microsoft Corporation. All rights reserved.
#############################################################################

Param(
    [string]$BranchName = "v-wedin/AddAzureScript"
)

$tsRootPath = Split-Path $MyInvocation.MyCommand.Definition
Push-Location $tsRootPath
Write-Host "TestSuite Root Path: $tsRootPath"
Set-Location .\TSHelper
$tsHelperPath = Get-Location

Write-Host "TestSuite Helper Folder Path: $tsHelperPath"

try {
    # Write-Host "Start to call git checkout $BranchName"
    # & "git fetch"
    # & "git checkout $BranchName"

    "git fetch" | Out-File "$tsHelperPath\checkoutbranch.cmd" -Encoding utf8    ## fetch all repo
    Add-Content -Path "$tsHelperPath\checkoutbranch.cmd" -Value "git checkout $BranchName" -Encoding utf8   ## checkout specified branch
    Add-Content -Path "$tsHelperPath\checkoutbranch.cmd" -Value "git pull origin $BranchName" -Encoding utf8    ## pull latest changes.

    Write-Host "Execute checkout branch"
    $batch = Start-Process -FilePath "$tsHelperPath\checkoutbranch.cmd" -Wait -passthru
    Write-Host ("Check out Helper repo complete, exit code:" + $batch.ExitCode)
    #Remove-Item "$tsHelperPath\checkoutbranch.cmd"
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

$toMerge = @('ProtoSDK', 'TestSuites', "AzureScripts")
$azureScriptPath = (Join-Path $tsRootPath "AzureScripts")
if ( Test-Path -Path $azureScriptPath) {
    Write-Host "AzureScript folder already exists, file will be override by Helper branch"
}
else {
    New-Item -ItemType Directory -Path $azureScriptPath
}

foreach($path in $toMerge){
    Write-Host "Starting merge: $path , please wait..."
    $sourcePath = Join-Path $tsHelperPath $path
    Copy-Item -Path $sourcePath -Destination $tsRootPath -Recurse -Force
}

Pop-Location

