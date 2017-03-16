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
$oldDefault = Get-WmiObject -Class Win32_Printer | Where-Object {$_.Default -eq $True}
 
# determine if there are any mapped printers on old server
$printers = @(Get-WmiObject -Class Win32_Printer -Filter "SystemName='\\\\$oldPrintServer'" -ErrorAction Stop)
 
# maps new printer based on hash literal defined above. Default printer is preserved.
If ($printers.count -gt 0) {
    ForEach ($printer in $printers) {
        If ($oldDefault.Name -eq $printer.Name){
            $newPrinter = $PrinterMap[$printer.Name]
            if($newprinter){
                ([wmiclass]"Win32_Printer").AddPrinterConnection($newPrinter).ReturnValue
                $e = $newPrinter.split('\')[3]               
                $newDefault = Get-WmiObject -Class Win32_Printer | Where-Object {$_.ShareName -eq "$e"}
                $newDefault.SetDefaultPrinter()
                Start-Sleep -Seconds 30
                $printer.Delete()
                }
            }
        Else {
            $newPrinter = $PrinterMap[$printer.Name]
            if($newprinter){
                ([wmiclass]"Win32_Printer").AddPrinterConnection($newPrinter).ReturnValue
                Start-Sleep -Seconds 30
                $printer.Delete()
                }
            }
        }
    }
