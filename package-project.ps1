# Golf Swing Tracker - Packaging Script
# Creates a ZIP file with complete project for distribution

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Golf Swing Tracker - Project Packager" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Set project directory
$projectRoot = "C:\GolfSwingTracker"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$zipFileName = "GolfSwingTracker-v1.0.0-$timestamp.zip"
$zipFilePath = Join-Path $env:USERPROFILE "Desktop\$zipFileName"

# Check if project exists
if (-not (Test-Path $projectRoot)) {
    Write-Host "ERROR: Project directory not found at $projectRoot" -ForegroundColor Red
    exit 1
}

Write-Host "Project Directory: $projectRoot" -ForegroundColor Green
Write-Host "Output Location: $zipFilePath" -ForegroundColor Green
Write-Host ""

# Remove existing ZIP if it exists
if (Test-Path $zipFilePath) {
    Write-Host "Removing existing ZIP file..." -ForegroundColor Yellow
    Remove-Item $zipFilePath -Force
}

# Define files and folders to exclude
$excludePatterns = @(
    "node_modules",
    ".git",
    ".gradle",
    "build",
    ".idea",
    "*.iml",
    ".DS_Store",
    "*.log",
    "coverage",
    ".expo",
    "dist",
    "*.hprof",
    ".cxx",
    "*.keystore",
    ".metro-health-check*"
)

Write-Host "Creating ZIP package..." -ForegroundColor Cyan
Write-Host "This may take a few moments..." -ForegroundColor Gray
Write-Host ""

try {
    # Change to project directory
    Set-Location $projectRoot

    # Get all files excluding patterns
    $filesToZip = Get-ChildItem -Path $projectRoot -Recurse -File | Where-Object {
        $file = $_
        $shouldExclude = $false
        
        foreach ($pattern in $excludePatterns) {
            if ($file.FullName -like "*$pattern*") {
                $shouldExclude = $true
                break
            }
        }
        
        -not $shouldExclude
    }

    Write-Host "Files to package: $($filesToZip.Count)" -ForegroundColor Green

    # Create ZIP file
    Compress-Archive -Path $projectRoot\* -DestinationPath $zipFilePath -Force

    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! Package created successfully!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Package Location: $zipFilePath" -ForegroundColor Cyan
    
    # Get file size
    $fileSize = (Get-Item $zipFilePath).Length / 1MB
    Write-Host "Package Size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "📦 Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Extract the ZIP file on target machine" -ForegroundColor White
    Write-Host "  2. Open terminal in extracted folder" -ForegroundColor White
    Write-Host "  3. Run: npm install" -ForegroundColor White
    Write-Host "  4. Run: npm run android" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 Read QUICKSTART.md for detailed setup instructions" -ForegroundColor Yellow
    Write-Host ""

    # Offer to open file location
    $openLocation = Read-Host "Open file location? (Y/N)"
    if ($openLocation -eq "Y" -or $openLocation -eq "y") {
        explorer.exe "/select,$zipFilePath"
    }

} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to create ZIP package" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "Done! 🎉" -ForegroundColor Green
