$url = 'https://notepad-plus-plus.org'
$webresponse = Invoke-WebRequest https://notepad-plus-plus.org/download
$installargs = '/S'

# RestAPI invoke
$download =  $url+ ($webresponse.Links | 
    Where-Object {$_.innerText -like "*Notepad++ Installer 32-Bit x86*"} | 
    Select-Object href -ExpandProperty href)

# Download binary and install
Invoke-WebRequest $download -UseBasicParsing -OutFile "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe"
Start-Process "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe" -ArgumentList $installargs #-Wait

#Uncomment the -Wait flag above and the command below to remove binary after install
# Remove-Item "$PSScriptRoot\Notepad-Plus-Plus-Latest-Installer.exe"