# Define variables for each package version
$packageName = "beavernotes"
$packageVersion = "1.0.0"
$packageUrl = "https://github.com/Daniele-rolli/Beaver-Notes/releases/download/$packageVersion/Beaver-notes.Setup.$packageVersion.exe"
$packageHash = "a470ccfdd744fb77503d8a4fd0746864c62b9905cb8987d3d22c459e709f3ebb"

# Check if the package version already exists
if (Test-Path (Join-Path $env:SCOOP_HOME\buckets\my-bucket\bucket\apps $packageName\$packageVersion)) {
    Write-Host "Package $packageName $packageVersion already exists. Exiting."
    exit
}

# Download and verify the package
Invoke-WebRequest -Uri $packageUrl -OutFile "$env:TEMP\$packageName-$packageVersion.exe"

# Create or update the package manifest
$manifest = @{
    version = $packageVersion
    license = "MIT"
    url = $packageUrl
    homepage = "https://beavernotes.com"
    hash = $packageHash
}
$manifest | ConvertTo-Json | Out-File (Join-Path $env:SCOOP_HOME\buckets\my-bucket\bucket\apps $packageName\$packageName.json)

# Commit changes and create a pull request
git add .
git commit -m "Add $packageName $packageVersion"
gh pr create --base main --head feature/add-$packageName-$packageVersion

# Clean up temporary files
Remove-Item "$env:TEMP\$packageName-$packageVersion.exe"

Write-Host "Pull request created for $packageName $packageVersion."
