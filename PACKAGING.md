# Package the Golf Swing Tracker Project

This script creates a distributable ZIP file of the complete project.

## Usage

### Option 1: Run directly
```powershell
.\package-project.ps1
```

### Option 2: Run with execution policy bypass
```powershell
powershell -ExecutionPolicy Bypass -File .\package-project.ps1
```

### Option 3: Manual ZIP creation
If the script doesn't work, manually create ZIP:
1. Select all files/folders in C:\GolfSwingTracker
2. Right-click → Send to → Compressed (zipped) folder
3. Name it: GolfSwingTracker-v1.0.0.zip

**Note**: Exclude these folders if zipping manually:
- node_modules (will be reinstalled)
- android/build (build artifacts)
- android/.gradle (cache)
- .git (version control)

## What Gets Packaged

### Included:
✅ Source code (src/)
✅ Android configuration (android/)
✅ Package configuration (package.json, tsconfig.json, etc.)
✅ Documentation (README.md, QUICKSTART.md, etc.)
✅ Build scripts
✅ Configuration files

### Excluded:
❌ node_modules (too large, will be downloaded)
❌ build artifacts
❌ cache files
❌ IDE configurations
❌ logs

## Package Contents

After extraction, users will have:
- Complete source code
- All configuration files
- Setup documentation
- Build scripts
- Ready to run after `npm install`

## Distribution

The created ZIP file can be:
- Shared via email
- Uploaded to cloud storage
- Distributed on USB drive
- Posted to file sharing service

## Recipient Instructions

1. Extract ZIP file
2. Open terminal in extracted folder
3. Run: `npm install`
4. Run: `npm run android`
5. Read QUICKSTART.md for details

---

**Package Size**: ~5-10 MB (without node_modules)  
**Full Install Size**: ~300-400 MB (with node_modules)
