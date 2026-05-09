$s = "C:\Windows\SystemApps"
$log = "C:\Temp\fixshell2.log"
$p1 = (Get-ChildItem "$s\*Search*\AppxManifest.xml").FullName
$p2 = (Get-ChildItem "$s\*StartMenu*\AppxManifest.xml").FullName
$p3 = (Get-ChildItem "$s\*ShellExp*\AppxManifest.xml").FullName
Add-AppxPackage -Register $p1 -DisableDevelopmentMode 2>&1 | Out-File $log
Add-AppxPackage -Register $p2 -DisableDevelopmentMode 2>&1 | Out-File $log -Append
Add-AppxPackage -Register $p3 -DisableDevelopmentMode 2>&1 | Out-File $log -Append
"Done" | Out-File $log -Append
