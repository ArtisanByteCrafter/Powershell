# Relaunch in x64 powershell if not already
if ($PSHOME -like '*syswow64*') {
  Write-Output 'Relaunching as x64'
  & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
  -File $Script:MyInvocation.MyCommand.Path `
  @args
  Exit
}

$zoomurl = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'
$zoomWebResponse = Invoke-WebRequest -Uri "$zoomurl" -Method Head -UseBasicParsing
$zoomfilename = $zoomWebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[3]

Start-BitsTransfer -Source $zoomWebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$zoomfilename
Start-Process -FilePath $PSScriptRoot\$zoomfilename -Wait
Remove-Item  -Path $PSScriptRoot\$zoomfilename
