Function Invoke-NotePadPlusPlusInstaller {
    param (    
        [string]
        [Parameter( HelpMessage = 'List install args')]
        $Params = "/S"
    )

    Begin {
        
    }
    Process {
        $url = 'https://notepad-plus-plus.org'
        $webresponse = Invoke-WebRequest https://notepad-plus-plus.org/download
        
        $download = $url + ($webresponse.Links | 
                Where-Object {$_.innerText -like "*Notepad++ Installer 32-Bit x86*"} | 
                Select-Object href -ExpandProperty href)

        Invoke-WebRequest $download -UseBasicParsing -OutFile "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe"
        Start-Process "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe" -ArgumentList $Params -Wait
        Remove-Item "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe"
    }
    End {
              
    }

}
Invoke-NotePadPlusPlusInstaller