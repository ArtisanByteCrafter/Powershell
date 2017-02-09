param
  (
    [String]
    [ValidateSet('x86','x64')]
    [Parameter(Mandatory=$true,HelpMessage='Specify x86 or x64')]
    $Architecture
  ) 
# Variables
$firefox32 = 'https://download.mozilla.org/?product=firefox-esr-latest&lang=en-US'
$firefox64 = 'https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US'
$parameters = '-ms'
$mozillaconfig = @'
// Disable updater
lockPref("app.update.enabled", false);
// make absolutely sure it is really off
lockPref("app.update.auto", false);
lockPref("app.update.mode", 0);
lockPref("app.update.service.enabled", false);

// Disable Add-ons compatibility checking
clearPref("extensions.lastAppVersion");

// Don't show 'know your rights' on first run
pref("browser.rights.3.shown", true);

// Don't show WhatsNew on first run after every update
pref("browser.startup.homepage_override.mstone","ignore");

// Set default homepage - users can change - set lockPref if not user changeable
defaultPref("browser.startup.homepage", "data:text/plain,browser.startup.homepage=http://www.google.com");

// Disable default browser check
lockPref("browser.shell.checkDefaultBrowser",	false);

// Disable the internal PDF viewer
// pref("pdfjs.disabled", true);

// Disable the flash to javascript converter
// pref("shumway.disabled", true);

// Don't ask to install the Flash plugin
pref("plugins.notifyMissingFlash", false);

//Disable plugin checking
lockPref("plugins.hide_infobar_for_outdated_plugin", true);
clearPref("plugins.update.url");

// Disable health reporter
lockPref("datareporting.healthreport.service.enabled", false);

// Disable crash reporter
lockPref("toolkit.crashreporter.enabled", false);
Components.classes["@mozilla.org/toolkit/crash-reporter;1"].getService(Components.interfaces.nsICrashReporter).submitReports = false;
'@
$autoconfig = @'
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);
'@
$override = @'
[XRE]
EnableProfileMigrator=false
'@


# Function to write configs
function Create-Configs { 
    Write-Output -InputObject $mozillaconfig | Out-File -Encoding Default -FilePath "${env:ProgramFiles(x86)}\Mozilla Firefox\mozilla.cfg"
    Write-Output -InputObject $autoconfig | Out-File -Encoding Default -FilePath "${env:ProgramFiles(x86)}\Mozilla Firefox\defaults\pref\autoconfig.js"
    Write-Output -InputObject $override | Out-File -Encoding Default -FilePath "${env:ProgramFiles(x86)}\Mozilla Firefox\override.ini"
    Write-Output -InputObject $override | Out-File -Encoding Default -FilePath "${env:ProgramFiles(x86)}\Mozilla Firefox\browser\override.ini"
} 


    If ($Architecture -eq 'x86') {
      $FFx86WebResponse = Invoke-WebRequest -Uri "$firefox32" -Method Head -UseBasicParsing
      $firefox32filename = $FFx86WebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[7] -Replace ('%20',' ')
      
      Start-BitsTransfer -Source $FFx86WebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$firefox32filename
      Start-Process -FilePath $PSScriptRoot\$firefox32filename -ArgumentList $parameters -Wait
      Create-Configs
      Remove-Item  -Path $PSScriptRoot\$firefox32filename
    } 
    
    If ($Architecture -eq 'x64') {
      $FFx64WebResponse = Invoke-WebRequest -Uri "$firefox64" -Method Head -UseBasicParsing
      $firefox64filename = $FFx64WebResponse.BaseResponse.ResponseUri.AbsolutePath.split('/')[7] -Replace ('%20',' ')
      
      Start-BitsTransfer -Source $FFx64WebResponse.BaseResponse.ResponseUri.AbsoluteUri -Destination $PSScriptRoot\$firefox64filename
      Start-Process -FilePath $PSScriptRoot\$firefox64filename -ArgumentList $parameters -Wait
      Create-Configs
      Remove-Item  -Path $PSScriptRoot\$firefox64filename
    }
        
   
