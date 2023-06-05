# Define the project root path (Active Directory in this case)
$projectRoot = Get-Location

# Initialize counters
$totalLOC = 0
$sourceLOC = 0

# Get all files recursively in the project root
$files = Get-ChildItem -Path $projectRoot -Recurse -File

# Iterate through each file
foreach ($file in $files) {
    try {
        # Attempt to read the content of the file as text
        $content = Get-Content -Path $file.FullName -Raw
    }
    catch {
        # Skip the file if it cannot be read as text
        continue
    }

    # Exclude binary files by checking for NUL characters in the content
    if ($content -match "[\x00]") {
        continue
    }

    # Count the total number of lines
    $totalLines = $content.Split("`n").Count

    # Count the lines of source code (excluding empty and comment lines)
    $sourceLines = ($content -split "`n" | Where-Object { $_ -match '\S' -and $_ -notlike '#*' }).Count

    # Update the counters
    $totalLOC += $totalLines
    $sourceLOC += $sourceLines
}

# Output the results
Write-Host "Total Lines of Code (LOC): $totalLOC"
Write-Host "Lines of Source Code (SLOC): $sourceLOC"