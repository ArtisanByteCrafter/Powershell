
Function Invoke-HandbrakeInstaller {
    param (    
        [string]
        [Parameter( HelpMessage = 'List install args')]
        $Params = "/S"
    )
    
    Begin {
       
    }

    Process {
        # fix for .NET and SSLv3 / TLS 1.1
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        $Latest = ((Invoke-WebRequest https://handbrake.fr/downloads.php -UseBasicParsing).links | Where-Object {$_.href -like "*-x86_64-Win_GUI.exe*"}).href
        $Latest = $Latest -replace ("^[^_]*file=", "")
        $Download = "https://handbrake.fr/mirror/$Latest"
        Invoke-WebRequest -Uri $Download -OutFile "$PSScriptRoot\Handbrake-latest.exe" 
        Start-Process "$PSScriptRoot\Handbrake-latest.exe" $Params -Wait
        Remove-Item "$PSScriptRoot\Handbrake-latest.exe"
        
    }

    End {

    }
}

Invoke-HandbrakeInstaller
