################################################################################
##  File:  Validate-Sbt.ps1
##  Team:  CI-Platform
##  Desc:  Validate sbt for Windows
################################################################################

if((Get-Command -Name 'sbt'))
{
    Write-Host "sbt $(sbt --script-version) is on the path"
}
else
{
    Write-Host "sbt is not on path."
    exit 1
}

$sbtVersion = $(sbt --script-version)

# Adding description of the software to Markdown
$SoftwareName = "sbt"

$Description = @"
_Version:_ $sbtVersion<br/>
_Environment:_
* PATH: contains location of sbt.bat
"@

Add-SoftwareDetailsToMarkdown -SoftwareName $SoftwareName -DescriptionMarkdown $Description
