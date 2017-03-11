#$DebugPreference = "Continue"
$white_list = "USBSTOR\DISK&VEN_&PROD_USB_DISK_3.0&REV_PMAP\07450324FA276B10&0","USBSTOR\DISK&VEN_&PROD_USB_DISK_3.0&REV_PMAP\03450324FA276A11&0"

function Get-DevicesID {
    Get-WmiObject Win32_USBControllerDevice | Foreach-Object { [Wmi]$_.Dependent | Select -ExpandProperty DeviceID }
    }

function Check-NewDevice {
    $actual_dev = Get-DevicesID
    Write-Debug ("New Devices = "+$actual_dev)
    $test = Compare-Object $actual_dev $global:init_dev
    if($test) {
        if($test.InputOBJECT -notcontains $white_list) {$true}
        }
    }

function Run-Action {
    Write-Debug "Run-Action"
    if(Check-NewDevice) {
        Write-Debug "Lock"
        rundll32.exe user32.dll, LockWorkStation
        }
    }

$global:init_dev = Get-DevicesID
Write-Debug ("Init Devices = "+$init_dev)
$query_event = "SELECT * FROM Win32_DeviceChangeEvent WHERE EventType = 2"
Register-WMIEvent -SourceIdentifier "USB_Monitor" -Query $query_event -Action { Run-Action } | Write-Debug