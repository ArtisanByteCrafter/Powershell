#requires -RunasAdministrator
if ($PSHOME -like "*syswow64*") {
    Write-Output 'Relaunching as x64'
    & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
        -File $Script:MyInvocation.MyCommand.Path `
        @args
    Exit
}
Function Invoke-VLCInstaller {
    param (    
        [string]
        [Parameter( HelpMessage = 'List install args')]
        $Params = "/S"
    )
    
    Begin {
       
    }

    Process {
        $Latest = ((Invoke-WebRequest http://download.videolan.org/pub/videolan/vlc/last/win64/ -UseBasicParsing).links | Where-Object {$_.href -match "(exe)+$"}).href
        $Download = "http://download.videolan.org/pub/videolan/vlc/last/win64/$Latest"
        Invoke-WebRequest -Uri $Download -OutFile "$PSScriptRoot\VLC-latest.exe" 
        Start-Process "$PSScriptRoot\VLC-latest.exe" $Params -Wait
        Remove-Item "$PSScriptRoot\VLC-latest.exe"
        #Remove unneccesary shortcuts
        $RemovalList = get-childitem -path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\"  -filter *.lnk | Where-Object {$_.Name -ne "VLC media player.lnk"}
        Foreach ($item in $RemovalList) {
            Remove-Item $item.FullName
        }

        # Sets the targetPath attribute to ignore update/Network and Privacy Settings on first Run
        $shortcuts = @(
            "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\VLC media player.lnk"
            "$env:PUBLIC\Desktop\VLC media player.lnk"
        )
            
        ForEach ($shortcut in $shortcuts) {
            $obj = new-object -comobject wscript.shell
            $link = $obj.CreateShortcut($shortcut)
            $link.Arguments = '--no-qt-privacy-ask'
            $link.Save()
        }
        Rename-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\VLC media player.lnk" -NewName "DVD Player and VLC Media Player.lnk"
        Rename-Item "$env:PUBLIC\Desktop\VLC media player.lnk" -NewName "DVD Player and VLC Media Player.lnk"
    }

    End {


    }
}

Invoke-VLCInstaller