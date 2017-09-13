Function Invoke-VSCodeInstaller {
    param (    
        [string]
        [Parameter( HelpMessage = 'List install args')]
        $Params = "/verysilent /suppressmsgboxes /mergetasks=!runcode"
    )
    
    Begin {
        
    }

    Process {
        Start-BitsTransfer -Source https://go.microsoft.com/fwlink/?LinkID=623230 -Destination "$PSScriptRoot\VSCode-latest.exe"
        Start-Process "$PSScriptRoot\VSCode-latest.exe" $Params -Wait
        Remove-Item "$PSScriptRoot\VSCode-latest.exe"
    }

    End {

    }
}

Invoke-VSCodeInstaller