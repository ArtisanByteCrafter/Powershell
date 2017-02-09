﻿Write-Output -InputObject 'Uninstalling default apps'
$apps = @(
    # default Windows 10 apps
    'Microsoft.3DBuilder'
    'Microsoft.Appconnector'
    'Microsoft.BingFinance'
    'Microsoft.BingNews'
    'Microsoft.BingSports'
    'Microsoft.BingWeather'
    'Microsoft.FreshPaint'
    'Microsoft.Getstarted'
    'Microsoft.MicrosoftOfficeHub'
    'Microsoft.MicrosoftSolitaireCollection'
    'Microsoft.MicrosoftStickyNotes'
    'Microsoft.Office.OneNote'
    'Microsoft.OneConnect'
    'Microsoft.People'
    'Microsoft.SkypeApp'
    'Microsoft.Windows.Photos'
    'Microsoft.WindowsAlarms'
    'Microsoft.WindowsCalculator'
    'Microsoft.WindowsCamera'
    'Microsoft.WindowsMaps'
    'Microsoft.WindowsPhone'
    'Microsoft.WindowsSoundRecorder'
    'Microsoft.WindowsStore'
    'Microsoft.XboxApp'
    'Microsoft.ZuneMusic'
    'Microsoft.ZuneVideo'
    'microsoft.windowscommunicationsapps'
    'Microsoft.MinecraftUWP'

    # Threshold 2 apps
    'Microsoft.CommsPhone'
    'Microsoft.ConnectivityStore'
    'Microsoft.Messaging'
    'Microsoft.Office.Sway'


    #Redstone apps
    'Microsoft.BingFoodAndDrink'
    'Microsoft.BingTravel'
    'Microsoft.BingHealthAndFitness'
    'Microsoft.WindowsReadingList'

    # non-Microsoft
    '9E2F88E3.Twitter'
    'Flipboard.Flipboard'
    'ShazamEntertainmentLtd.Shazam'
    'king.com.CandyCrushSaga'
    'king.com.CandyCrushSodaSaga'
    'king.com.*'
    'ClearChannelRadioDigital.iHeartRadio'
    '4DF9E0F8.Netflix'
    '6Wunderkinder.Wunderlist'
    'Drawboard.DrawboardPDF'
    '2FE3CB00.PicsArt-PhotoStudio'
    'D52A8D61.FarmVille2CountryEscape'
    'TuneIn.TuneInRadio'
    'GAMELOFTSA.Asphalt8Airborne'
    #"TheNewYorkTimes.NYTCrossword"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
)

foreach ($app in $apps) {
    Write-Output -InputObject "Trying to remove $app"

    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage

    Get-AppXProvisionedPackage -Online |
        Where-Object DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}