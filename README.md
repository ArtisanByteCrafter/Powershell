# Powershell
## About this project
I write these helpful scripts to help automate my own deployments, and I try to open-source everything I can (whenever I can remember to commit)

* Installers
    * These are (mostly) unattended, silent installers written (mostly) as functions that can either be called directly by the .ps1 script, or put into a module. I might re-organize this as a module if I get some time.


## Miscellaneous Notes

You might notice a lot of the `Begin{}` and `End{}` script blocks are empty in some advanced functions - As noted above, I sanitize my installers of any employment specific data, but they will work perfectly fine without anything there. If you'd like to give a popup message that stuff and things are happening, put this in the `Begin` bracket:

````powershell
$box = new-object -comobject wscript.shell 
$box.popup("$appname is being installed. You will receive a confirmation when it is complete.", 10, 'Your ORG Name', 4096)
````

Then, again in the `End`

````powershell
$box = new-object -comobject wscript.shell 
$box.popup("$appname has been installed.", 10, 'Your ORG Name', 4096)
````

## Erm... Why not [Chocolatey](https://chocolatey.org/)? Bro, do you even [Ninite](https://ninite.com/)?
These are amazing tools, and I love that they exist. Check 'em out! I chose to write these due to:
* A shameless excuse to write more Powershell
* A way to give my use cases the flexibility they needed.