$remove = @('*Java*', '*Opera*' )

function Get-InstalledApps {
param (
[Parameter(ValueFromPipeline=$true)]
[string[]]$ComputerName = $env:COMPUTERNAME,
[string]$NameRegex = ''
)

    foreach ($comp in $ComputerName) {
    $keys = '','\Wow6432Node'
        foreach ($key in $keys) {
        try {
            $apps = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$comp).OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames()
        } catch {
            continue
        }

            foreach ($app in $apps) {
            $program = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$comp).OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall\$app")
            $name = $program.GetValue('DisplayName')
                if ($name -and $name -match $NameRegex) {
                      [pscustomobject]@{
                      ComputerName = $comp
                      DisplayName = $name
                      DisplayVersion = $program.GetValue('DisplayVersion')
                      Publisher = $program.GetValue('Publisher')
                      InstallDate = $program.GetValue('InstallDate')
                      UninstallString = $program.GetValue('UninstallString')
                      Bits = $(if ($key -eq '\Wow6432Node') {'64'} else {'32'})
                      Path = $program.name
                      }
                }
            }
        }
    }
}

$array = Foreach ($r in $remove){
  Get-InstalledApps | Where-Object {$_.DisplayName -like $r } | Select-Object -ExpandProperty UninstallString
}

ForEach ($a in $array) {
  & "$env:ComSpec" /c $a /quiet
}
