Write-Host "Generating logs for chkdsk..."
get-winevent -FilterHashTable @{logname="Application"; id="1001"}| ?{$_.providername -match "wininit"} | fl timecreated, message | out-file "$env:USERPROFILE/Desktop/CHKDSKResults.txt"
Write-Host "Done! Look for CHKDSKResults.txt on the desktop!"
Read-Host -Prompt "Press Enter to exit"
