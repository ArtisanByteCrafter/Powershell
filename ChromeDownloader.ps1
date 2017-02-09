# Relaunch in x64 powershell if not already
if ($PSHOME -like '*syswow64*') {
    Write-Output 'Relaunching as x64'
    & (Join-Path ($PSHOME -replace 'syswow64', 'sysnative') powershell.exe) `
        -File $Script:MyInvocation.MyCommand.Path `
        @args
    Exit
}
$chromeurl = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi'

$masterpreferences = @'
{
  "browser" : {
    "check_default_browser" : false
  },
  "distribution" : {
    "import_bookmarks" : false,
    "import_history" : false,
    "import_home_page" : false,
    "import_search_engine" : false,
    "suppress_first_run_bubble" : true,
    "do_not_create_desktop_shortcut" : true,
    "do_not_create_quick_launch_shortcut" : true,
    "do_not_create_taskbar_shortcut" : true,
    "do_not_launch_chrome" : true,
    "do_not_register_for_update_launch" : true,
    "make_chrome_default" : false,
    "make_chrome_default_for_user" : false,
    "msi" : true,
    "require_eula" : false,
    "suppress_first_run_default_browser_prompt" : true,
    "system_level" : true,
    "verbose_logging" : true
  },
  "first_run_tabs" : [
    "chrome://newtab"
  ],
  "homepage" : "chrome://newtab",
  "homepage_is_newtabpage" : true,
  "sync_promo" : {
    "show_on_first_run_allowed" : false
  }
} 
'@
$parameters = '/qn'
$chromeWebResponse = Invoke-WebRequest -Uri "$chromeurl" -Method Head -UseBasicParsing
$chromefilename = $chromeWebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[6]

Start-BitsTransfer -Source $chromeWebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$chromefilename
Start-Process -FilePath $PSScriptRoot\$chromefilename -ArgumentList $parameters -Wait

Write-Output $masterpreferences | Out-File -Encoding Default -FilePath "${env:ProgramFiles(x86)}\Google\Chrome\Application\master_preferences"
Remove-Item  -Path $PSScriptRoot\$chromefilename