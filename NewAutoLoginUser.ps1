# Relaunch in x64 powershell if not already
if ($PSHOME -like "*syswow64*") {
    Write-Output 'Relaunching as x64'
    & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
        -File $Script:MyInvocation.MyCommand.Path `
        @args
    Exit
}
Function New-AutoLoginUser {
  Param(
    [Parameter(Mandatory=$True)]
    [string]$name,
	
    [Parameter(Mandatory=$True)]
    [string]$password
  )
  $Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

  $LocalAdmin = $Computer.Create('User', "$name")
  $LocalAdmin.SetPassword("$password")
  $LocalAdmin.SetInfo()
  $LocalAdmin.FullName = "$name"
  $LocalAdmin.SetInfo()
  $LocalAdmin.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
  $LocalAdmin.SetInfo()
  & "$env:windir\system32\net.exe" LOCALGROUP 'Users' "$name" /add
}


If (!(Get-WmiObject -class Win32_UserAccount | Where-Object {$_.Name -eq '$name'})) {

    New-AutoLoginUser -name '$name' -password '$name'
    # Evaluate and set Registry for auto login
          $path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
          $key = Get-Item -Path $path -ErrorAction Stop

          If ($key.GetValue('AutoAdminLogon') -ne '1') {
              Set-ItemProperty -Path "$path" -Name 'AutoAdminLogon' -Value '1'
          }

          If ($key.GetValue('DefaultUserName') -ne 'student') {
              Set-ItemProperty -Path "$path" -Name 'DefaultUserName' -Value 'student'
          }

          If ($key.GetValue('DefaultPassword') -ne 'student') {
              Set-ItemProperty -Path "$path" -Name 'DefaultPassword' -Value 'student'
          }
            ElseIf (!$key.GetValue('DefaultPassword')){
              New-ItemProperty -Path "$path" -Name 'DefaultPassword' -Value 'student' -PropertyType String
            }
    }