<#
.SYNTAX       write-motd.ps1
.DESCRIPTION  writes the message of the day (MOTD)
.LINK         https://github.com/fleschutz/PowerShell
.NOTES        Author: Markus Fleschutz / License: CC0
#>


$WinFormDLL = $($env:WinDir) + '\Microsoft.NET\Framework64\v4.0.30319\System.Windows.Forms.dll'
Add-Type -Path $WinFormDLL -ErrorAction SilentlyContinue # Required for to get cursor position

#Region Generate Windows Flag

Write-Host ""
# Save the current positions. If StayOnSameLine switch is supplied, we should go back to these.
$x = [System.Console]::get_CursorLeft()
$y = [System.Console]::get_CursorTop()
$CurrForegroundColor = [System.Console]::ForegroundColor
$CurrBackgroundColor = [System.Console]::BackgroundColor

Write-Host ""
Write-Host " ,.=:^!^!t3Z3z., " -ForegroundColor Red

Write-Host " :tt:::tt333EE3 " -ForegroundColor Red

Write-Host " Et:::ztt33EEE " -ForegroundColor Red -NoNewline
Write-Host " @Ee., ..,     " -ForegroundColor green

Write-Host " ;tt:::tt333EE7" -ForegroundColor Red -NoNewline
Write-Host " ;EEEEEEttttt33# " -ForegroundColor Green

Write-Host " :Et:::zt333EEQ." -NoNewline -ForegroundColor Red
Write-Host " SEEEEEttttt33QL " -ForegroundColor Green

Write-Host " it::::tt333EEF" -NoNewline -ForegroundColor Red
Write-Host " @EEEEEEttttt33F " -ForegroundColor Green

Write-Host " ;3=*^``````'*4EEV" -NoNewline -ForegroundColor Red
Write-Host " :EEEEEEttttt33@. " -ForegroundColor Green

Write-Host " ,.=::::it=., " -NoNewline -ForegroundColor Cyan
Write-Host "``" -NoNewline -ForegroundColor Red
Write-Host " @EEEEEEtttz33QF " -ForegroundColor Green

Write-Host " ;::::::::zt33) " -NoNewline -ForegroundColor Cyan
Write-Host " '4EEEtttji3P* " -ForegroundColor Green

Write-Host " :t::::::::tt33." -NoNewline -ForegroundColor Cyan
Write-Host ":Z3z.. " -NoNewline -ForegroundColor Yellow
Write-Host " ````" -NoNewline -ForegroundColor Green
Write-Host " ,..g. " -ForegroundColor Yellow

Write-Host " i::::::::zt33F" -NoNewline -ForegroundColor Cyan
Write-Host " AEEEtttt::::ztF " -ForegroundColor Yellow

Write-Host " ;:::::::::t33V" -NoNewline -ForegroundColor Cyan
Write-Host " ;EEEttttt::::t3 " -NoNewline -ForegroundColor Yellow
Write-Host ""

Write-Host " E::::::::zt33L" -NoNewline -ForegroundColor Cyan
Write-Host " @EEEtttt::::z3F " -NoNewline -ForegroundColor Yellow
Write-Host ""

Write-Host " {3=*^``````'*4E3)" -NoNewline -ForegroundColor Cyan
Write-Host " ;EEEtttt:::::tZ`` " -NoNewline -ForegroundColor Yellow
Write-Host ""

Write-Host "              ``" -NoNewline -ForegroundColor Cyan
Write-Host " :EEEEtttt::::z7 " -NoNewline -ForegroundColor Yellow
Write-Host ""

Write-Host "                 'VEzjt:;;z>*`` " -ForegroundColor Yellow
Write-Host ""
$x_end = [System.Console]::get_CursorLeft()
$y_end = [System.Console]::get_CursorTop()

#EndRegion Generate Windows Flag


#Region Retrieve information:
$Delay = 1
$x = 33
$y += 0

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Computer System: " -NoNewline -ForegroundColor Red
$ComputerSystem = Get-WmiObject -Class win32_computersystem
$Mke = $ComputerSystem.Manufacturer
$Mdl = (($ComputerSystem.Model).Replace($Mke, "")).Trim()
$Mdl = $Mdl.Replace("20L7002CUS", "$Mdl (aka= T480s)")
$Mdl = $Mdl.Replace("20L6S1E700", "$Mdl (aka= T480)")
$Mdl = $Mdl.Replace("20L6S0XV00", "$Mdl (aka= T480)")
$Mdl = $Mdl.Replace("20NX002XUS", "$Mdl (aka= T490)")
$Mdl = $Mdl.Replace("20NKS3BS00", "$Mdl (aka= T495)")
$ComputerSystem = $Mke + "`t" + $Mdl
Write-Host "$ComputerSystem" -ForegroundColor Cyan
<#
Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewLine
Write-Host "CPU: " -NoNewline -ForegroundColor Red
$Processor = Get-CimInstance -ClassName Win32_Processor | ForEach-Object { $_.Name }
$CPU_Info = " [" + $Processor.NumberOfCores + " cores / " + $Processor.NumberOfLogicalProcessors + " threads]"
Write-Host $Processor.Name -ForegroundColor Cyan -NoNewline
Write-Host "$CPU_Info" -ForegroundColor Blue
 #>
Get-CimInstance -ClassName Win32_Processor | ForEach-Object {
    $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
    Write-Host "$($_.DeviceID) : " -NoNewline -ForegroundColor Red
    Write-Host "$($_.Name)  " -ForegroundColor Cyan -NoNewline
    $CPU_Info = " [" + $_.NumberOfCores + " cores / " + $_.NumberOfLogicalProcessors + " threads]"
    Write-Host "$CPU_Info" -ForegroundColor Blue -NoNewline
    Write-Host " ( $($_.MaxClockSpeed)GHz )" -ForegroundColor DarkGray
}


Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Processes: " -NoNewline -ForegroundColor Red
$NumberOfProcesses = (Get-Process).Count
Write-Host "$NumberOfProcesses" -ForegroundColor Cyan -NoNewline
Write-Host "     Current CPU Load: " -NoNewline -ForegroundColor Red
$Current_Load = $Processor.LoadPercentage
Write-Host "$Current_Load%" -ForegroundColor Cyan

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Memory: " -NoNewline -ForegroundColor Red
$Memory_Size = Get-CimInstance Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize # output in KB
$Memory_Size = "$([math]::Round($Memory_Size.FreePhysicalMemory / 1KB)) MBs free of $([math]::Round($Memory_Size.TotalVisibleMemorySize / 1KB)) MBs Total"
Write-Host "$Memory_Size" -ForegroundColor Cyan

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Hostname: " -NoNewline -ForegroundColor Red
Write-Host "$(hostname)" -ForegroundColor Cyan


Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "OS: " -NoNewline -ForegroundColor Red
$OSInfo = (Get-WmiObject Win32_OperatingSystem  | Select-Object Caption, BuildNumber, OSArchitecture)
$OSName = $OSInfo.OSArchitecture + " " + $OSInfo.Caption + " " + $OSInfo.BuildNumber
Write-Host "$OSName" -ForegroundColor Cyan

Get-WmiObject Win32_VideoController | Select-Object DeviceID, Description, AdapterRAM, Name, VideoProcessor, status, DriverVersion, CurrentHorizontalResolution, CurrentVerticalResolution, CurrentRefreshRate | ForEach-Object {
    $Video_InfoA = " [ " + [math]::round($_.AdapterRAM / 1GB, 1) + "GB VRAM" + " /  Drv Ver: " + $_.DriverVersion + " ]"
    $Video_InfoB = " (" + $_.CurrentHorizontalResolution + "x" + $_.CurrentVerticalResolution + " @ " + $_.CurrentRefreshRate + "Hz)"
    Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
    Write-Host "$(($_.DeviceID).Replace("VideoController","GPU")): " -NoNewline -ForegroundColor Red
    Write-Host "$Video_InfoA " -ForegroundColor Blue -NoNewline
    Write-Host "$Video_InfoB " -ForegroundColor Gray -NoNewline
    Write-Host "$($_.Name)" -ForegroundColor Cyan

}

function Decode { If ($args[0] -is [System.Array]) { [System.Text.Encoding]::ASCII.GetString($args[0]) }Else { "Not Found" } }

ForEach ($Monitor in Get-WmiObject WmiMonitorID -Namespace root\wmi) {
    $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
    $Name = Decode $Monitor.UserFriendlyName -notmatch 0
    $Serial = Decode $Monitor.SerialNumberID -notmatch 0
    # $ManufactureWeek = (Get-WmiObject WmiMonitorID -Namespace root\wmi).WeekofManufacture
    # $ManufactureYear = (Get-WmiObject WmiMonitorID -Namespace root\wmi).YearOfManufacture
    <#
    echo "Manufacturer: $Manufacturer`nName: $Name`nSerial Number: $Serial"
    echo "Week of Manufacture: $ManufactureWeek"
    echo "Year of Manufacture: $ManufactureYear"
 #>
    Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
    Write-Host "Monitor: " -NoNewline -ForegroundColor Red
    Write-Host "$Manufacturer`t$Name " -ForegroundColor Cyan -NoNewline
    Write-Host "`t[ S/N: $Serial ]" -ForegroundColor Blue
}

Get-NetAdapter -ErrorAction SilentlyContinue | Select-Object interfaceDescription, name, status, linkSpeed, ifIndex | ForEach-Object {
    $Interface_Info = $_.linkSpeed + " / "
    Get-NetIPAddress -InterfaceIndex $_.ifIndex -ErrorAction SilentlyContinue | Where-Object -Property AddressFamily -Like "*IPv4*" | Select-Object IPAddress, SubnetMask | ForEach-Object {
        $Interface_Info += $_.IPAddress
    }
    Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
    Write-Host "Interface: " -NoNewline -ForegroundColor Red
    Write-Host " [ " -NoNewline -ForegroundColor Blue
    If ($_.status -eq 'Up') {
        Write-Host "( Up ) " -ForegroundColor Green -NoNewline
    }
    else {
        Write-Host "(Down) " -ForegroundColor yellow -NoNewline
    }
    Write-Host "$Interface_Info ] " -ForegroundColor Blue -NoNewline
    Write-Host "$($_.name)" -ForegroundColor Cyan
}

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "ExtIPv4: " -NoNewline -ForegroundColor Red
$Location = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$((Invoke-WebRequest ifconfig.me/ip).Content.Trim())"
Write-Host "$($Location.query) " -ForegroundColor Cyan -NoNewline
Write-Host "[ Loc: " -ForegroundColor Blue -NoNewline
Write-Host "$($Location.city), $($Location.regionName)  ($($Location.lat) / $($Location.lon))" -ForegroundColor Gray -NoNewline
Write-Host " ]" -ForegroundColor Blue

$SystemDrive = (Get-WmiObject win32_operatingsystem).systemdrive
[System.IO.DriveInfo]::getdrives() | Where-Object { $_.DriveType -ne 'Network' } | ForEach-Object {
    $Drive_Info = $_.DriveFormat + " / " + $_.DriveType + " / Lbl: """ + $_.VolumeLabel + """ / " + [math]::round($_.AvailableFreeSpace / 1GB, 1) + "GBs Free / " + [math]::round($_.TotalSize / 1GB, 1) + "GBs Total ]"
    Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
    Write-Host "Drive: " -NoNewline -ForegroundColor Red
    Write-Host "$($_.Name)" -ForegroundColor Cyan -NoNewline
    Write-Host " [ " -NoNewline -ForegroundColor Blue
    If ($_.Name -like "*$SystemDrive*") {
        Write-Host "(OS Drive) " -ForegroundColor Green -NoNewline
    }
    Write-Host "$Drive_Info" -ForegroundColor Blue
}

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "PowerShell: " -NoNewline -ForegroundColor Red
$PowerShellVersion = $PSVersionTable.PSVersion
$PowerShellEdition = $PSVersionTable.PSEdition
Write-Host "$PowerShellVersion $PowerShellEdition" -ForegroundColor Cyan

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "User: " -NoNewline -ForegroundColor Red
Write-Host "$(whoami)" -ForegroundColor Cyan

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Time: " -ForegroundColor Red -NoNewline
$CurrentTime = Get-Date -Format "yyyy-MMM-dd HH:mm"
$TimeZone = (Get-TimeZone).id
Write-Host "$CurrentTime " -ForegroundColor Cyan -NoNewline
Write-Host "$TimeZone" -ForegroundColor blue

Start-Sleep -Milliseconds $Delay; $x += 0 ; $y += 1; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y } ; Write-Host -Fore White "| " -NoNewline
Write-Host "Uptime: " -NoNewline -ForegroundColor Red
$Uptime = New-TimeSpan -Start $((Get-CimInstance -ClassName win32_operatingsystem ).lastbootuptime) -End $(Get-Date)
$Uptime = "$(($uptime).Days) days, $(($uptime).Hours) hours, $(($uptime).Minutes) minutes and $(($uptime).Seconds) seconds"
Write-Host "$Uptime" -ForegroundColor Cyan

#EndRegion Retrieve information:

$x += 0 ; $y += 1
If ($y -gt $y_end) { $y_end = $y }
Start-Sleep -Milliseconds $Delay; $x = $x_end ; $y = $y_end; $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y }
exit 0

<#
Loop thru local drives
[System.IO.DriveInfo]::getdrives() | Where-Object {$_.DriveType -eq 'Fixed'}
[System.IO.DriveInfo]::getdrives() | Where-Object {$_.DriveType -ne 'Network'} | Select-Object -Property Name

Loop thru GPUs

 #>