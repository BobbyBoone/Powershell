Write-Output "---- CPU top 5 -----"
Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | `
  where-object{ $_.Name -ne "_Total" -and $_.Name -ne "Idle"} | `
  Sort-Object PercentProcessorTime -Descending | `
  select -First 5 | `
  Format-Table Name,IDProcess,PercentProcessorTime -AutoSize

  Write-Output "---- memory top 5  -----"
  Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | `
  where-object{ $_.Name -ne "_Total" -and $_.Name -ne "Idle"} | `
  Sort-Object PrivateBytes  -Descending | `
  select -First 5 | `
  Format-Table Name,IDProcess,PrivateBytes  -AutoSize

$os = Get-Ciminstance Win32_OperatingSystem
$pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
 
if ($pctFree -ge 45) {
$Status = "OK"
}
elseif ($pctFree -ge 15 ) {
$Status = "Warning"
}
else {
$Status = "Critical"
}
 
$os | Select @{Name = "Status";Expression = {$Status}},
@{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}



Stop-Process -Name "BlueJeans.Detector" -Force 2>&1 | out-null
Stop-Process -Name "splunkd" -Force   2>&1 | out-null
Stop-Process -Name "SearchUI" -Force   2>&1 | out-null
Stop-Process -Name "MicrosoftEdge" -Force   2>&1 | out-null
Stop-Process -Name "MicrosoftEdgeCP" -Force   2>&1 | out-null
