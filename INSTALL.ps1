# Golf Swing Tracker - Installation Script
# PowerShell version with enhanced features

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Golf Swing Tracker - Android Setup Installer" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will guide you through installing" -ForegroundColor White
Write-Host "the required Android development environment." -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to begin"

# Step 1: Check Node.js
Write-Host ""
Write-Host "[Step 1/5] Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "[OK] Node.js is installed: $nodeVersion" -ForegroundColor Green
    } else {
        throw "Not installed"
    }
} catch {
    Write-Host "[ERROR] Node.js is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Node.js first:" -ForegroundColor Yellow
    Write-Host "1. Visit: https://nodejs.org" -ForegroundColor White
    Write-Host "2. Download LTS version (18 or higher)" -ForegroundColor White
    Write-Host "3. Install with default settings" -ForegroundColor White
    Write-Host "4. Restart this script" -ForegroundColor White
    Write-Host ""
    $open = Read-Host "Open Node.js download page? (Y/N)"
    if ($open -eq "Y" -or $open -eq "y") {
        Start-Process "https://nodejs.org"
    }
    exit 1
}

# Step 2: Check Java
Write-Host ""
Write-Host "[Step 2/5] Checking Java JDK..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    if ($javaVersion) {
        Write-Host "[OK] Java is installed: $javaVersion" -ForegroundColor Green
    } else {
        throw "Not installed"
    }
} catch {
    Write-Host "[ERROR] Java JDK is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Java JDK:" -ForegroundColor Yellow
    Write-Host "1. Visit: https://adoptium.net" -ForegroundColor White
    Write-Host "2. Download JDK 17 or higher" -ForegroundColor White
    Write-Host "3. Install with default settings" -ForegroundColor White
    Write-Host "4. Restart this script" -ForegroundColor White
    Write-Host ""
    $open = Read-Host "Open Java download page? (Y/N)"
    if ($open -eq "Y" -or $open -eq "y") {
        Start-Process "https://adoptium.net"
    }
    exit 1
}

# Step 3: Check Android SDK
Write-Host ""
Write-Host "[Step 3/5] Checking Android SDK..." -ForegroundColor Yellow
try {
    $adbVersion = adb version 2>&1 | Select-Object -First 1
    if ($adbVersion) {
        Write-Host "[OK] Android SDK is installed: $adbVersion" -ForegroundColor Green
    } else {
        throw "Not installed"
    }
} catch {
    Write-Host "[WARNING] Android SDK not found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You need to install Android Studio:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Installation Steps:" -ForegroundColor White
    Write-Host "1. Visit: https://developer.android.com/studio" -ForegroundColor Gray
    Write-Host "2. Download Android Studio" -ForegroundColor Gray
    Write-Host "3. During installation, ensure these are selected:" -ForegroundColor Gray
    Write-Host "   - Android SDK" -ForegroundColor Gray
    Write-Host "   - Android SDK Platform" -ForegroundColor Gray
    Write-Host "   - Android SDK Build-Tools" -ForegroundColor Gray
    Write-Host "   - Android Emulator" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. After installation, open Android Studio" -ForegroundColor Gray
    Write-Host "5. Go to: Tools > SDK Manager" -ForegroundColor Gray
    Write-Host "6. Install:" -ForegroundColor Gray
    Write-Host "   - Android SDK Platform 34" -ForegroundColor Gray
    Write-Host "   - Android SDK Build-Tools 34.0.0" -ForegroundColor Gray
    Write-Host "   - Android SDK Platform-Tools" -ForegroundColor Gray
    Write-Host ""
    Write-Host "7. Set Environment Variables:" -ForegroundColor Yellow
    Write-Host "   Variable: ANDROID_HOME" -ForegroundColor Gray
    Write-Host "   Value: C:\Users\$env:USERNAME\AppData\Local\Android\Sdk" -ForegroundColor Gray
    Write-Host ""
    Write-Host "8. Add to PATH:" -ForegroundColor Yellow
    Write-Host "   %ANDROID_HOME%\platform-tools" -ForegroundColor Gray
    Write-Host "   %ANDROID_HOME%\tools" -ForegroundColor Gray
    Write-Host ""
    Write-Host "9. RESTART your computer" -ForegroundColor Yellow
    Write-Host "10. Run this script again" -ForegroundColor Yellow
    Write-Host ""
    
    $open = Read-Host "Open Android Studio download page? (Y/N)"
    if ($open -eq "Y" -or $open -eq "y") {
        Start-Process "https://developer.android.com/studio"
    }
    Write-Host ""
    Write-Host "Run this script again after installation!" -ForegroundColor Cyan
    Read-Host "Press Enter to exit"
    exit 1
}

# Step 4: Check for devices
Write-Host ""
Write-Host "[Step 4/5] Checking for connected devices..." -ForegroundColor Yellow
Write-Host ""
$devices = adb devices 2>&1
Write-Host $devices
Write-Host ""

$deviceCount = ($devices | Select-String "device$").Matches.Count
if ($deviceCount -eq 0) {
    Write-Host "[WARNING] No devices detected!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You need either:" -ForegroundColor White
    Write-Host "  A) An Android phone with USB debugging enabled" -ForegroundColor Gray
    Write-Host "  B) An Android emulator running" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "[OK] Found $deviceCount device(s) connected!" -ForegroundColor Green
    Write-Host ""
}

# Step 5: Choose action
Write-Host ""
Write-Host "[Step 5/5] Choose your option:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Install dependencies and build app (I have a device ready)" -ForegroundColor White
Write-Host "2. Help me set up an Android emulator" -ForegroundColor White
Write-Host "3. Show me physical device connection instructions" -ForegroundColor White
Write-Host "4. Run quick environment test" -ForegroundColor White
Write-Host "5. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    "1" {
        # Install and Build
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  Installing Dependencies..." -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        
        Set-Location $PSScriptRoot
        
        Write-Host "Running: npm install" -ForegroundColor Gray
        Write-Host "This may take 5-10 minutes on first run..." -ForegroundColor Yellow
        Write-Host ""
        
        npm install
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "[ERROR] npm install failed!" -ForegroundColor Red
            Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        Write-Host ""
        Write-Host "[OK] Dependencies installed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  Building and Running App..." -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        
        # Start Metro in new window
        Write-Host "Starting Metro bundler in new window..." -ForegroundColor Gray
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; npm start"
        
        Write-Host "Waiting 10 seconds for Metro to start..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        Write-Host ""
        Write-Host "Building and installing app on device..." -ForegroundColor Gray
        Write-Host ""
        
        npm run android
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "[ERROR] Build failed!" -ForegroundColor Red
            Write-Host ""
            Write-Host "Common issues:" -ForegroundColor Yellow
            Write-Host "1. No device connected - Connect device or start emulator" -ForegroundColor White
            Write-Host "2. USB debugging not enabled - Enable in device settings" -ForegroundColor White
            Write-Host "3. Metro bundler not ready - Wait 10 more seconds and try: npm run android" -ForegroundColor White
            Write-Host ""
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Green
        Write-Host "  SUCCESS! App launching on your device" -ForegroundColor Green
        Write-Host "================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "The Metro bundler is running in another window." -ForegroundColor White
        Write-Host "Keep it open while using the app." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Useful commands:" -ForegroundColor Cyan
        Write-Host "  npm run android - Rebuild and install" -ForegroundColor Gray
        Write-Host "  Press 'R' twice in app - Reload" -ForegroundColor Gray
        Write-Host "  Shake device - Open developer menu" -ForegroundColor Gray
        Write-Host ""
        Read-Host "Press Enter to exit"
    }
    
    "2" {
        # Emulator help
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  Android Emulator Setup Guide" -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Steps to create an Android emulator:" -ForegroundColor White
        Write-Host ""
        Write-Host " 1. Open Android Studio" -ForegroundColor Gray
        Write-Host " 2. Click 'More Actions' menu" -ForegroundColor Gray
        Write-Host " 3. Select 'Virtual Device Manager'" -ForegroundColor Gray
        Write-Host " 4. Click 'Create Device'" -ForegroundColor Gray
        Write-Host " 5. Choose 'Phone' category" -ForegroundColor Gray
        Write-Host " 6. Select 'Pixel 5' or similar" -ForegroundColor Gray
        Write-Host " 7. Click 'Next'" -ForegroundColor Gray
        Write-Host " 8. Select system image (Android 11+)" -ForegroundColor Gray
        Write-Host "    - Click 'Download' if needed" -ForegroundColor Gray
        Write-Host " 9. Click 'Next', then 'Finish'" -ForegroundColor Gray
        Write-Host "10. Click Play button to start emulator" -ForegroundColor Gray
        Write-Host "11. Wait for full boot (1-2 minutes)" -ForegroundColor Gray
        Write-Host "12. Run this script again, choose option 1" -ForegroundColor Gray
        Write-Host ""
        
        $open = Read-Host "Open emulator documentation? (Y/N)"
        if ($open -eq "Y" -or $open -eq "y") {
            Start-Process "https://developer.android.com/studio/run/managing-avds"
        }
    }
    
    "3" {
        # Device help
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  Physical Device Setup Guide" -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "STEP 1: Enable Developer Options" -ForegroundColor Yellow
        Write-Host "--------------------------------" -ForegroundColor Gray
        Write-Host "1. Open Settings on Android phone" -ForegroundColor White
        Write-Host "2. Go to 'About phone'" -ForegroundColor White
        Write-Host "3. Find 'Build number'" -ForegroundColor White
        Write-Host "4. Tap 'Build number' 7 times" -ForegroundColor White
        Write-Host "5. You'll see 'You are now a developer!'" -ForegroundColor White
        Write-Host ""
        Write-Host "STEP 2: Enable USB Debugging" -ForegroundColor Yellow
        Write-Host "----------------------------" -ForegroundColor Gray
        Write-Host "1. Go back to main Settings" -ForegroundColor White
        Write-Host "2. Look for 'Developer options'" -ForegroundColor White
        Write-Host "3. Enable 'USB debugging'" -ForegroundColor White
        Write-Host "4. Enable 'Install via USB' (if available)" -ForegroundColor White
        Write-Host ""
        Write-Host "STEP 3: Connect Device" -ForegroundColor Yellow
        Write-Host "----------------------" -ForegroundColor Gray
        Write-Host "1. Connect phone to PC with USB cable" -ForegroundColor White
        Write-Host "2. On phone: 'Allow USB debugging?' prompt" -ForegroundColor White
        Write-Host "3. Check 'Always allow from this computer'" -ForegroundColor White
        Write-Host "4. Tap 'OK' or 'Allow'" -ForegroundColor White
        Write-Host ""
        Write-Host "STEP 4: Verify Connection" -ForegroundColor Yellow
        Write-Host "-------------------------" -ForegroundColor Gray
        Write-Host "1. Open PowerShell/Command Prompt" -ForegroundColor White
        Write-Host "2. Type: adb devices" -ForegroundColor White
        Write-Host "3. Should see your device listed" -ForegroundColor White
        Write-Host ""
        Write-Host "Run this script again when device is connected!" -ForegroundColor Cyan
        Write-Host ""
        Read-Host "Press Enter to continue"
    }
    
    "4" {
        # Environment test
        Write-Host ""
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "  Environment Test" -ForegroundColor Cyan
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host ""
        
        Write-Host "Node.js:" -ForegroundColor Yellow
        node --version
        
        Write-Host ""
        Write-Host "npm:" -ForegroundColor Yellow
        npm --version
        
        Write-Host ""
        Write-Host "Java:" -ForegroundColor Yellow
        java -version 2>&1 | Select-Object -First 3
        
        Write-Host ""
        Write-Host "Android Debug Bridge:" -ForegroundColor Yellow
        adb version 2>&1 | Select-Object -First 1
        
        Write-Host ""
        Write-Host "Environment Variables:" -ForegroundColor Yellow
        Write-Host "ANDROID_HOME: $env:ANDROID_HOME" -ForegroundColor Gray
        Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Gray
        
        Write-Host ""
        Write-Host "Connected Devices:" -ForegroundColor Yellow
        adb devices
        
        Write-Host ""
        Read-Host "Press Enter to continue"
    }
    
    "5" {
        Write-Host ""
        Write-Host "Exiting..." -ForegroundColor Gray
        exit 0
    }
    
    default {
        Write-Host ""
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Installation script finished." -ForegroundColor Green
Read-Host "Press Enter to exit"
