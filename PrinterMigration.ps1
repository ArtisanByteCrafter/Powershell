$newPrintServer = 'newprintserver'
$oldPrintServer = 'oldprintserver'

$PrinterMap = @{
"\\$oldPrintServer\old-printer-name01" = "\\$newPrintServer\new-printer-name-01"
"\\$oldPrintServer\old-printer-name02" = "\\$newPrintServer\new-printer-name-02"
"\\$oldPrintServer\old-printer-name03" = "\\$newPrintServer\new-printer-name-03"
"\\$oldPrintServer\old-printer-name04" = "\\$newPrintServer\new-printer-name-04"
"\\$oldPrintServer\old-printer-name05" = "\\$newPrintServer\new-printer-name-05"
"\\$oldPrintServer\old-printer-name06" = "\\$newPrintServer\new-printer-name-06"
"\\$oldPrintServer\old-printer-name07" = "\\$newPrintServer\new-printer-name-07"
}

# get old default printer
$Default = Get-WmiObject -Query " SELECT * FROM Win32_Printer WHERE Default=$true"

# determine if there are any mapped printers on old server
$printers = @(Get-WmiObject -Class Win32_Printer -Filter "SystemName='\\\\$oldPrintServer'" -ErrorAction Stop)

# maps new printer based on hash literal defined above. Default printer is preserved.
If ($printers.count -gt 0) {
    ForEach ($printer in $printers) {
        If ($Default.Name -eq $printer.Name){
            $newPrinter = $PrinterMap[$printer.Name]
            if($newprinter){
                $defaultValue = ([wmiclass]"Win32_Printer").AddPrinterConnection($newPrinter).ReturnValue
                $e = $newPrinter.Substring(16)
                $a = Get-WMIObject -query "Select * From Win32_Printer Where ShareName = '$e'"
                $a.SetDefaultPrinter()
                Start-Sleep -Seconds 120
                $printer.Delete()
                }
            }
        Else {
            $newPrinter = $PrinterMap[$printer.Name]
            if($newprinter){
                $returnValue = ([wmiclass]"Win32_Printer").AddPrinterConnection($newPrinter).ReturnValue
                Start-Sleep -Seconds 120
                $printer.Delete()
                }
            }
        }
    }