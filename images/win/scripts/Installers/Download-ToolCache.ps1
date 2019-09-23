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
		Write-Host "Installing npm $packageName package"
		$null = npm install $packageName --registry=$NpmRegistry *>&1
	}
}

$Dest = "C:/"
$Path = "hostedtoolcache/windows"
$ToolsDirectory = $Dest + $Path

setx AGENT_TOOLSDIRECTORY $ToolsDirectory /M

$env:AGENT_TOOLSDIRECTORY = $ToolsDirectory
 
$PythonVersionsToolcacheInstall = @(
	"toolcache-python-windows-x64@2.7",
	"toolcache-python-windows-x86@2.7",
	"toolcache-python-windows-x64@3.4",
	"toolcache-python-windows-x86@3.4",
	"toolcache-python-windows-x64@3.5",
	"toolcache-python-windows-x86@3.5",
	"toolcache-python-windows-x64@3.6",
	"toolcache-python-windows-x86@3.6",
	"toolcache-python-windows-x64@3.7",
	"toolcache-python-windows-x86@3.7"
)

Install-NpmPackage -Name $PythonVersionsToolcacheInstall

#junction point from the previous Python2 directory to the toolcache Python2
$python2Dir = (Get-Item -Path ($ToolsDirectory + '/Python/2.7*/x64')).FullName
cmd.exe /c mklink /d "C:\Python27amd64" "$python2Dir"


