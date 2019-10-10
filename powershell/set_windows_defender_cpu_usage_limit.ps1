# Usage: set_windows_defender_cpu_usage.ps1 NUMBER
# NUMBER must between 0 (unlimited) and 100
# See https://docs.microsoft.com/en-us/powershell/module/defender/set-mppreference

if (([string]::IsNullOrEmpty($args[0]))) {
    Write-Host "[ERROR] Missing parameter. You must provide a first parameter as an integer between 0 and 100."
}
else {
    [int]$cpu = $args[0];
    if ($cpu -lt 0 -Or $cpu -gt 100) {
        Write-Host "[ERROR] Incorrect parameter. You must provide a first parameter as an integer between 0 and 100."
    }
    else {
        Write-Host "[INFO] Setting Windows Defender CPU usage limit to $cpu%."
        Set-MpPreference -ScanAvgCPULoadFactor $cpu
    }
}
