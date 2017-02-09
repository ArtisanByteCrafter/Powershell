$path = $PSScriptRoot
$oracle = "$env:USERPROFILE\appdata\locallow\oracle"

if(Test-Path $oracle)
{    
    $MSI = DIR "$oracle\Java\jre*" -Recurse -Include *.MSI
    Copy-Item -Path $MSI.FullName -Destination $path
}
else
{
    Write-Output "Folder not found, check for EXE"

    $EXE = Dir "$path/jre-*.exe"
    if($EXE)
    {
        $process = Start-Process $EXE.FullName
        Start-sleep 20


        $MSI = DIR "$oracle\Java\jre*" -Recurse -Include *.MSI
        Copy-Item -Path $MSI.FullName -Destination $path

        $process | Stop-Process
    }
}