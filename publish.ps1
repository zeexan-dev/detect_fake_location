# Format the Dart code
dart format .

# Run a dry run of the publish command
dart pub publish --dry-run

# Prompt the user to continue
$choice = Read-Host "Do you want to proceed with the publish? (y/n)"
if ($choice -ne "y") {
    Write-Host "Publishing aborted."
    exit
}

# Ask for the version number
$version = Read-Host "Enter the version number for the tag (e.g., 0.0.1)"

# Check if the tag already exists
$tagExists = git rev-parse "v$version" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Error: Tag 'v$version' already exists." -ForegroundColor Red
    Write-Host "To delete the existing tag, run the following commands:"
    Write-Host "git tag -d v$version"
    Write-Host "git push origin :refs/tags/v$version"
    exit
}

# Add the tag and push it to the origin
git tag "v$version"
git push origin "v$version"

# Finally, publish the package
dart pub publish --force