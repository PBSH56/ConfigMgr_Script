# PowerShell Script to Delete CCMCache data older than 30 days
# Author: Prabhat Kumar
# Date: 2025-08-27

# Define CCMCache folder path (custom location)
$CachePath = "C:\Windows\ccmcache"

# Check if CCMCache folder exists
if (Test-Path $CachePath) {
    Write-Output "CCMCache folder found at: $CachePath"
    
    # Get all subfolders and files older than 30 days
    $OldCache = Get-ChildItem -Path $CachePath -Recurse |
                Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }

    if ($OldCache) {
        foreach ($Item in $OldCache) {
            try {
                Write-Output "Deleting: $($Item.FullName) (Last modified: $($Item.LastWriteTime))"
                Remove-Item -Path $Item.FullName -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to delete $($Item.FullName): $_"
            }
        }
        Write-Output "Cleanup completed successfully."
    }
    else {
        Write-Output "No cache data older than 30 days found."
    }
}
else {
    Write-Warning "CCMCache folder not found at $CachePath."
}
