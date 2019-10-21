################################################################################
##  File:  Download-ToolCache.ps1
##  Team:  CI-Build
##  Desc:  Download tool cache
################################################################################

Function Install-NpmPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.String[]]
        $Name,
        [System.String]
        $NpmRegistry="https://buildcanary.pkgs.visualstudio.com/PipelineCanary/_packaging/hostedtoolcache/npm/registry/"
    )

    foreach($packageName in $Name) {
        Write-Host "Installing npm '$packageName' package from '$NpmRegistry'"
        npm install $packageName --registry=$NpmRegistry
    }
}

Function InstallTool {
    [CmdletBinding()]
    param(
        [System.IO.FileInfo]$ExecutablePath
    )

    Set-Location -Path $ExecutablePath.DirectoryName -PassThru | Write-Host
    if (Test-Path 'tool.zip') {
        Expand-Archive 'tool.zip' -DestinationPath '.'
    }
    cmd.exe /c 'install_to_tools_cache.bat'
}

# ToolCache Blob
$SourceUrl = "https://vstsagenttools.blob.core.windows.net/tools"

# HostedToolCache Path
$Dest = "C:/"
$Path = "hostedtoolcache/windows"
$ToolsDirectory = $Dest + $Path

# Add AzCopy to the Path
$env:Path = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy;" + $env:Path
Write-Host "Started AzCopy from $SourceUrl to $Dest"
AzCopy /Source:$SourceUrl /Dest:$Dest /S /V /Pattern:$Path

# Temporary remove Python and Python
Remove-Item -Path C:\hostedtoolcache\windows\Python -Force -Recurse
Remove-Item -Path C:\hostedtoolcache\windows\Ruby -Force -Recurse

# Install ToolCache
Push-Location -Path $ToolsDirectory

Get-ChildItem -Recurse -Depth 4 -Filter install_to_tools_cache.bat | ForEach-Object {
    InstallTool -ExecutablePath $_
}

Pop-Location

# Define AGENT_TOOLSDIRECTORY environment variable
$env:AGENT_TOOLSDIRECTORY = $ToolsDirectory
setx AGENT_TOOLSDIRECTORY $ToolsDirectory /M

# Install Python ToolCache
$PythonVersionsToolcacheInstall = @(
    "toolcache-python-windows-x64@2.7"
    "toolcache-python-windows-x86@2.7"
    "toolcache-python-windows-x64@3.4"
    "toolcache-python-windows-x86@3.4"
    "toolcache-python-windows-x64@3.5"
    "toolcache-python-windows-x86@3.5"
    "toolcache-python-windows-x64@3.6"
    "toolcache-python-windows-x86@3.6"
    "toolcache-python-windows-x64@3.7"
    "toolcache-python-windows-x86@3.7"
)

$RubyVersionsToolcacheInstall = @(
    "toolcache-ruby-windows-x64@2.4"
    "toolcache-ruby-windows-x64@2.5"
    "toolcache-ruby-windows-x64@2.6"
)

Install-NpmPackage -Name $PythonVersionsToolcacheInstall
Install-NpmPackage -Name $RubyVersionsToolcacheInstall

#junction point from the previous Python2 directory to the toolcache Python2
$python2Dir = (Get-Item -Path ($ToolsDirectory + '/Python/2.7*/x64')).FullName
cmd.exe /c mklink /d "C:\Python27amd64" "$python2Dir"
