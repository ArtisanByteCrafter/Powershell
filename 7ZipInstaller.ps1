Function Invoke-7ZipInstaller {
    param (    
        [string]
        [Parameter( HelpMessage = 'List install args')]
        $Params = '/S'
    )
    
    Begin {
        $appname = '7Zip'
        $filename = '7Zip-latest.exe'
        $url = 'http://www.7-zip.org'
        $request = Invoke-WebRequest $url -UseBasicParsing
        $download = ($url + '/' + ($request.links | Where-Object {$_.outerHTML -like "*Download*"}).href[1])
        
    }

    Process {
        Start-BitsTransfer -Source $download -Destination $PSScriptRoot\$filename
        Start-Process "$PSScriptRoot\$filename" $Params -Wait
        Remove-Item "$PSScriptRoot\$filename"
    }

    End {

    }
}

Invoke-7ZipInstaller