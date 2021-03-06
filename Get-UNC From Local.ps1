<#
.SYNOPSIS
	Script to self-elevate and map a drive to the location it was it was started from
  
.DESCRIPTION
    This script is intended to get PowerShell to self-elevate and map a drive letter to 
    a \\Server\Share UNC path where the script is ran from based on the existing 
    [letter]:\folder\[ThisScript].ps1 path.  It is to be a code snippet to be included into
    a larger script to potentially execute Windows Batch (.BAT) scripts that reside on server
    shares and need to be executed from same location.  Due to limitations of .BAT files, they
    cannot be run over \\server\share\ paths and still access the filesystem of that location.
    
.PARAMETER <Parameter_Name>
    None, process driven
   
.CRITERIA
    Ability to run process with Admin Privileges

.OUTPUTS
  Console only

.NOTES
  Version:        1.0
  Author:         Bart Strauss / https://github.com/SuperBartimus
  Link:           https://github.com/SuperBartimus/Misc-PowerShell_Scripts/blob/main/Get-UNC%20From%20Local.ps1
  Creation Date:  2021 Jul 21
  Purpose/Change: Make it possible to run Batch scripts or other functions that require elevated permissions on a mapped drive.

.Disclosure
    This script is available for use using the GNU LESSER GENERAL PUBLIC LICENSE Version 3, 29 June 2007
    https://www.gnu.org/licenses/lgpl-3.0.txt
    
#>
Clear-Host

### Turn on Debugging messages here.  Comment/Delete to turn off.
$DebugPreference = "Continue"

### Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {

    $path = $PSCommandPath
    Write-Debug $Path

  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

### Now running elevated so launch the script:
Write-Debug Elevated

$Path = $PSCommandPath #Getting the FullPath of this script
$MappedPath = $path
$currentDrive = Split-Path -qualifier $path #getting drive letter
$logicalDisk = Get-WmiObject Win32_LogicalDisk -filter "DeviceID = '$currentDrive'"
if ($logicalDisk.DriveType -eq 4) # Determining drive type.  '4' means network.  If it's a network drive do stuff
{
    $path = Join-Path $logicalDisk.ProviderName (Split-Path -NoQualifier $path) # Finding the full UNC Path to this script
    $ShareRoot = Split-Path -Parent $logicalDisk.ProviderName # Finding the \\Server\Share path to use for mapping a new drive
    $MappedLoca = "X: --> " + $ShareRoot # for informational use
    $WorkinPath = Split-Path -Parent $Path # Noticed in the current enviroment the script was built in, there was an addition folder depth that needed to be removed.
    $WorkinPath = $WorkinPath.Replace("$ShareRoot","") # reference previous comment
    $WorkinPath = "X:" + $WorkinPath # putting the drive letter to the new 'relative' path -- X:\SubFolderOfShare\SubFolder
    
}
### Debugging Block
Write-Debug "Mapped Drive: $MappedPath"
Write-Debug "Drive Letter: $currentDrive"
Write-Debug "Log Disk Pro: $logicalDisk.ProviderName"
Write-Debug "UNC Path    : $path "
Write-Debug "Share Root  : $ShareRoot"
Write-Debug "Mapped Loca : $MappedLoca"
Write-Debug ""
Write-Debug "Workin Path : $WorkinPath"
Write-Debug "Manual Path : O:\Group - Hardware\Environment\Domain\PCs\New PC Setup\Scripts"
Write-Debug "PScmd  Path : $PSCommandPath "
Write-Debug ""
### End of Debugging Block

New-PSDrive –Name “X” –PSProvider FileSystem –Root $ShareRoot | Out-Null # Map the drive.  Will not show up in My Computer though
Set-Location -Path $WorkinPath # Set the location of where the script is operating to the new drive letter, but where this script is at on the folder hierachy
Dir -Name # just listing contents -- proof of function
Pause
