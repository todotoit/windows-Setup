@echo off
cls
echo Running Windows Killer Script!
echo Checking Administrator rights...
SET PATH=%PATH%;c:\Tools

net session >nul 2>&1
if %errorlevel%==0 (
    echo You are Administrator! Proceeding...
) else (
    echo You are not Administrator!
    echo Please run again this script with Administrator rights!
    echo Press any key to exit...
    pause
    exit
)

echo [Set Ethernet connection to metered (Disable Windows 10 Auto updates)]
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f
echo [Set Default connection to metered (Disable Windows 10 Auto updates)]
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Default /t REG_DWORD /d 2 /f
echo [Set Wifi connection to metered (Disable Windows 10 Auto updates)]
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f
echo [Stop Windows Update Service]
net stop wuauserv
sc config wuauserv start= disabled
echo [Disable 'Updates are available' pop up]
cd /d "%Windir%\System32"
takeown /f musnotification.exe
icacls musnotification.exe /deny Everyone:(X)
takeown /f musnotificationux.exe
icacls musnotificationux.exe /deny Everyone:(X)
echo [Disable Screen and Hard Disk Stand-by]
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0
echo [Ignore Error at reboot when Auto-Power On is Enabled]
bcdedit /set {default} bootstatuspolicy ignoreshutdownfailures
echo [Enable Wake On Lan port on Windows Firewall]
netsh advfirewall firewall add rule name="TLI_Wake-on-LAN" dir=in action=allow profile=any localport=9 protocol=TCP edge=yes
netsh advfirewall firewall add rule name="TLI_Wake-on-LAN" dir=in action=allow profile=any localport=9 protocol=UDP edge=yes
echo All operations completed! Press enter to close this window...
echo [Make computer reachable by Ping]
netsh advfirewall firewall set rule name="Condivisione file e stampanti (richiesta echo - ICMPv4-In)" dir=in new enable=Yes
pause