
Function Invoke-JavaDownload { 
    <#
      
      .DESCRIPTION
       Download Java x86 or x64 (or both) on a machine.

      .PARAMETER Architecture
      -Specify the OS Architecture (x86), (x64)


      .EXAMPLE
      -Downloads Java(x86) to the root of the script's working directory:

      Invoke-JavaDownload -Architecture x86

      --Downloads Java(x86), and Java(x64) to the root of the script's working directory:

      Invoke-JavaDownload -Architecture x86,x64

  #>
    [CmdletBinding()] 
    
    param (
        [String[]]
        [ValidateSet('x86', 'x64')]
        [Parameter(Mandatory = $true, HelpMessage = 'Specify x86 or x64')]
        $Architecture
    )
 
    Begin {
        # Download offline installers. 
        $downloadPage = Invoke-WebRequest -Uri 'http://www.java.com/en/download/manual.jsp' 
        $x86Download = ($downloadPage.Links | Where-Object { $_.innerText -eq 'Windows Offline' }).href 
        $x64Download = ($downloadPage.Links | Where-Object { $_.innerText -eq 'Windows Offline (64-Bit)' }).href 

    } # End Begin Block

    Process {
        If ($Architecture -contains 'x86') {
            $WebResponse = Invoke-WebRequest -Uri $x86Download -Method Head -UseBasicParsing 
            Start-BitsTransfer -Source $WebResponse.BaseResponse.ResponseUri.AbsoluteUri  -Destination "$PSScriptRoot\java_x86.exe"
         
        }
        If ($Architecture -contains 'x64') {
            $WebResponse = Invoke-WebRequest -Uri $x64Download -Method Head -UseBasicParsing 
            Start-BitsTransfer -Source $WebResponse.BaseResponse.ResponseUri.AbsoluteUri  -Destination "$PSScriptRoot\java_x64.exe"
        }
    } # End Process Block
} # End Function Invoke-JavaDownload

Function Invoke-JavaInstall {
    <#
      
      .DESCRIPTION
       Installs Java x86 or x64 (or both) on a machine.

      .PARAMETER Architecture
      -Specify the OS Architecture (x86), (x64)
      
      .PARAMETER Params
      -Specify the install arguments to be used during the install.


      .EXAMPLE
      -Installs Java(x86) to the local machine:

      Invoke-JavaInstall -Architecture x86

      -Installs Java(x86) and Java(x64) to the local machine:

      Invoke-JavaInstall -Architecture x86,x64

  #>
    param (
        [String[]]
        [ValidateSet('x86', 'x64')]
        [Parameter(Mandatory = $true, HelpMessage = 'Specify x86 or x64')]
        $Architecture,
        
        [string]
        [Parameter(Mandatory = $true, HelpMessage = 'List install args')]
        $Params
    )
    Begin {
        $box = new-object -comobject wscript.shell 
        $box.popup("Java $Architecture is being installed. You will receive a confirmation when it is complete.", 10, 'Java Installer', 4096)

    } # End Begin Block
    Process {
        If ($Architecture -contains 'x86') {
            Start-Process "$PSScriptRoot\java_x86.exe" -ArgumentList $params -Wait
            Remove-Item "$PSScriptRoot\java_x86.exe"
        }
        If ($Architecture -contains 'x64') {
            Start-Process "$PSScriptRoot\java_x64.exe" -ArgumentList $params -Wait
            Remove-Item "$PSScriptRoot\java_x64.exe"
        }    
    } # End Process Block
    End {
        $box = new-object -comobject wscript.shell 
        $box.popup("Java $Architecture has been installed.", 10, 'Java Installer', 4096)

    } # End 'End' Block
} # End Function Invoke-JavaInstall
