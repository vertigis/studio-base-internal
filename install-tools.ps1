Get-WindowsCapability -Online -Name RSAT.ActiveDirectory.* | Add-WindowsCapability -Online
Add-WindowsCapability -Online -Name OpenSSH.Client | Add-WindowsCapability -Online
Import-Module ActiveDirectory

