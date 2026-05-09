$log = "C:\Temp\regfix.log"
"Starting RegFixSearch..." | Out-File $log

# Enable SeTakeOwnershipPrivilege and SeRestorePrivilege
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class TokenUtil {
    [DllImport("advapi32.dll", ExactSpelling=true, SetLastError=true)]
    static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr tok);
    [DllImport("advapi32.dll", SetLastError=true)]
    static extern bool LookupPrivilegeValue(string sys, string name, ref long luid);
    [DllImport("advapi32.dll", ExactSpelling=true, SetLastError=true)]
    static extern bool AdjustTokenPrivileges(IntPtr tok, bool dis, ref TP tp, int len, IntPtr prev, IntPtr ret);
    [StructLayout(LayoutKind.Sequential, Pack=1)]
    struct TP { public int Count; public long Luid; public int Attr; }
    const int TOKEN_ADJUST = 0x20, TOKEN_QUERY = 8, SE_ENABLED = 2;
    public static void Enable(string priv) {
        IntPtr t = IntPtr.Zero;
        OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, TOKEN_ADJUST|TOKEN_QUERY, ref t);
        TP tp = new TP { Count=1, Attr=SE_ENABLED };
        LookupPrivilegeValue(null, priv, ref tp.Luid);
        AdjustTokenPrivileges(t, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
    }
}
'@

[TokenUtil]::Enable("SeTakeOwnershipPrivilege")
[TokenUtil]::Enable("SeRestorePrivilege")
"Privileges enabled" | Out-File $log -Append

$regPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications"

# Take ownership as Administrators
$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    $regPath,
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,
    [System.Security.AccessControl.RegistryRights]::TakeOwnership
)
$acl = $key.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
$acl.SetOwner([System.Security.Principal.NTAccount]"BUILTIN\Administrators")
$key.SetAccessControl($acl)
$key.Close()
"Ownership taken" | Out-File $log -Append

# Grant Administrators FullControl
$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    $regPath,
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,
    [System.Security.AccessControl.RegistryRights]::ChangePermissions
)
$acl = $key.GetAccessControl()
$rule = New-Object System.Security.AccessControl.RegistryAccessRule(
    "BUILTIN\Administrators","FullControl","ContainerInherit","None","Allow"
)
$acl.AddAccessRule($rule)
$key.SetAccessControl($acl)
$key.Close()
"FullControl granted to Administrators" | Out-File $log -Append

# Fix the InboxApplications key
$base = "HKLM:\$regPath"
$old = "Microsoft.Windows.Search_10.0.20348.1_neutral_neutral_cw5n1h2txyewy"
$new = "Microsoft.Windows.Search_1.15.0.20348_neutral_neutral_cw5n1h2txyewy"
$p = (Get-ItemProperty "$base\$old").Path

New-Item -Path "$base\$new" -Force | Out-Null
New-ItemProperty -Path "$base\$new" -Name Path -Value $p -PropertyType String -Force | Out-Null
Remove-Item -Path "$base\$old" -Force

"Fixed: $new" | Out-File $log -Append
"Path: $p" | Out-File $log -Append
Get-ChildItem $base | Where-Object { $_.PSChildName -match "Search" } | Select-Object PSChildName | Out-File $log -Append
"Done" | Out-File $log -Append
