if($hyperv.State -eq "Enabled") {
    Write-Host "Hyper-V is enabled."
} else {
    Write-Host "Hyper-V is disabled."
}