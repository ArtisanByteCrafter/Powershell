[CmdletBinding()]
param
( [Parameter(ValueFromPipeline = $true)]
  [String]
  $ComputerName = $env:COMPUTERNAME
)

$CompSystem = Get-WmiObject -Class Win32_ComputerSystem -Namespace root/cimv2 -ComputerName $ComputerName
$OpSystem = Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName $ComputerName

$lastreboot = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName |
    Select-Object -Property CSName,@{n='Last Booted'
      e={[Management.ManagementDateTimeConverter]::ToDateTime($_.LastBootUpTime)}} | Select-Object -ExpandProperty 'Last Booted'

$serial = Get-WmiObject -Class Win32_Bios -ComputerName $ComputerName | Select-Object -ExpandProperty SerialNumber
$networkinfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Namespace 'root\CimV2' -ComputerName $ComputerName |
 Where-Object {$_.IPAddress -ne $null -and $_.Description -notlike 'VM*'}


  
  
$data = [pscustomobject]@{
  'Name' = $CompSystem.Name
  'Description' = $OpSystem.Description
  'Domain' = $CompSystem.Domain
  'Current Console User' = $CompSystem.UserName
  'Windows Version' = $OpSystem.Caption + ' ' + $OpSystem.OSArchitecture
  'IPV4 Address' = $networkinfo.IPAddress | Select-Object -First 1
  'Mac Address' = $networkinfo.MacAddress | Select-Object -First 1
  'Manufacturer' = $CompSystem.Manufacturer
  'Model' = $CompSystem.Model
  'Last Boot Time' = $lastreboot 
  'BIOS Serial' = $serial
}

$data