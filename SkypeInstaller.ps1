# Relaunch in x64 powershell if not already
if ($PSHOME -like '*syswow64*') {
    Write-Output 'Relaunching as x64'
    & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
    -File $Script:MyInvocation.MyCommand.Path `
    @args
    Exit
  }
  $url = 'http://www.skype.com/go/getskype-full'
  $parameters = '/VERYSILENT /SP- /NOCANCEL /NORESTART /SUPPRESSMSGBOXES /NOLAUNCH'
  
  $WebResponse = Invoke-WebRequest -Uri "$url" -Method Head -UseBasicParsing
  $filename = $WebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[2]
  
  Start-BitsTransfer -Source $WebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$filename
  Start-Process -FilePath $PSScriptRoot\$filename -ArgumentList $parameters -Wait
  Remove-Item  -Path $PSScriptRoot\$filename
  