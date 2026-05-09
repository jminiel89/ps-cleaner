$base = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications"
$old = "Microsoft.Windows.Search_10.0.20348.1_neutral_neutral_cw5n1h2txyewy"
$new = "Microsoft.Windows.Search_1.15.0.20348_neutral_neutral_cw5n1h2txyewy"
$log = "C:\Temp\regfix.log"

$p = (Get-ItemProperty "$base\$old").Path
New-Item -Path "$base\$new" -Force | Out-Null
New-ItemProperty -Path "$base\$new" -Name Path -Value $p -PropertyType String -Force | Out-Null
Remove-Item -Path "$base\$old" -Force

"Fixed: $new" | Out-File $log
"Path: $p" | Out-File $log -Append
Get-ChildItem $base | Where-Object { $_.PSChildName -match "Search" } | Select-Object PSChildName | Out-File $log -Append
"Done" | Out-File $log -Append
