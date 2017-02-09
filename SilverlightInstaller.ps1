# Relaunch in x64 powershell if not already
if ($PSHOME -like '*syswow64*') {
  Write-Output 'Relaunching as x64'
  & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
  -File $Script:MyInvocation.MyCommand.Path `
  @args
  Exit
}
$silverlighturl = 'http://go.microsoft.com/fwlink/?LinkID=229321'
$parameters = '/q'

$silverlightWebResponse = Invoke-WebRequest -Uri "$silverlighturl" -Method Head -UseBasicParsing
$silverlightfilename = $silverlightWebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[7]

Start-BitsTransfer -Source $silverlightWebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$silverlightfilename
Start-Process -FilePath $PSScriptRoot\$silverlightfilename -ArgumentList $parameters -Wait
Remove-Item  -Path $PSScriptRoot\$silverlightfilename
