@echo off
echo ================================================
echo   Golf Swing Tracker - Android Setup Installer
echo ================================================
echo.
echo This script will guide you through installing
echo the required Android development environment.
echo.
pause

echo.
echo [Step 1/5] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo Please install Node.js first:
    echo 1. Visit: https://nodejs.org
    echo 2. Download LTS version
    echo 3. Install with default settings
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Node.js is installed
    node --version
)

echo.
echo [Step 2/5] Checking Java JDK...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java JDK is not installed!
    echo.
    echo Please install Java JDK:
    echo 1. Visit: https://adoptium.net
    echo 2. Download JDK 17 or higher
    echo 3. Install with default settings
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Java is installed
    java -version 2>&1 | findstr "version"
)

echo.
echo [Step 3/5] Checking Android SDK...
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Android SDK not found!
    echo.
    echo You need to install Android Studio:
    echo.
    echo 1. Visit: https://developer.android.com/studio
    echo 2. Download Android Studio
    echo 3. During installation, make sure to install:
    echo    - Android SDK
    echo    - Android SDK Platform
    echo    - Android SDK Build-Tools
    echo    - Android Emulator
    echo.
    echo 4. After installation, open Android Studio
    echo 5. Go to: Tools ^> SDK Manager
    echo 6. Install:
    echo    - Android SDK Platform 34
    echo    - Android SDK Build-Tools 34.0.0
    echo    - Android SDK Platform-Tools
    echo.
    echo 5. Add to System Environment Variables:
    echo    Variable: ANDROID_HOME
    echo    Value: C:\Users\%USERNAME%\AppData\Local\Android\Sdk
    echo.
    echo 6. Add to PATH:
    echo    %%ANDROID_HOME%%\platform-tools
    echo    %%ANDROID_HOME%%\tools
    echo.
    echo 7. RESTART your computer
    echo 8. Run this script again
    echo.
    echo Opening Android Studio download page...
    start https://developer.android.com/studio
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Android SDK is installed
    adb version 2>&1 | findstr "Version"
)

echo.
echo [Step 4/5] Checking for connected devices...
adb devices
echo.
echo Do you see any devices listed above?
echo - If YES, you're ready to build!
echo - If NO, you need to either:
echo   A) Connect an Android phone with USB debugging enabled
echo   B) Start an Android emulator from Android Studio
echo.

echo [Step 5/5] Choose your option:
echo.
echo 1. I have a device/emulator ready - Install dependencies and build
echo 2. Help me set up an Android emulator
echo 3. Show me device connection instructions
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto emulator_help
if "%choice%"=="3" goto device_help
if "%choice%"=="4" goto end

:install
echo.
echo ================================================
echo   Installing Dependencies...
echo ================================================
echo.
cd /d "%~dp0"
echo Installing npm packages (this may take 5-10 minutes)...
call npm install
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] npm install failed!
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   Building and Running App...
echo ================================================
echo.
echo Starting Metro bundler...
start "Metro Bundler" cmd /k "cd /d "%~dp0" && npm start"
echo.
echo Waiting 5 seconds for Metro to start...
timeout /t 5 /nobreak >nul
echo.
echo Building and installing app on device...
call npm run android
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Build failed!
    echo.
    echo Common issues:
    echo 1. No device connected - Connect device or start emulator
    echo 2. USB debugging not enabled - Enable in device settings
    echo 3. Metro bundler not ready - Wait 10 more seconds and try: npm run android
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   SUCCESS! App should be launching on your device
echo ================================================
echo.
echo The Metro bundler is running in another window.
echo Keep it open while using the app.
echo.
echo To rebuild: npm run android
echo To reload app: Press 'R' twice in app or shake device
echo.
pause
goto end

:emulator_help
echo.
echo ================================================
echo   Android Emulator Setup Guide
echo ================================================
echo.
echo 1. Open Android Studio
echo 2. Click on "More Actions" menu
echo 3. Select "Virtual Device Manager"
echo 4. Click "Create Device"
echo 5. Choose "Phone" category
echo 6. Select "Pixel 5" or similar device
echo 7. Click "Next"
echo 8. Select a system image (e.g., "R" - Android 11)
echo    - If not downloaded, click "Download" first
echo 9. Click "Next", then "Finish"
echo 10. Click the Play button to start the emulator
echo 11. Wait for emulator to fully boot (1-2 minutes)
echo 12. Run this script again and choose option 1
echo.
echo Opening Android Studio Device Manager docs...
start https://developer.android.com/studio/run/managing-avds
echo.
pause
goto end

:device_help
echo.
echo ================================================
echo   Physical Device Setup Guide
echo ================================================
echo.
echo STEP 1: Enable Developer Options
echo --------------------------------
echo 1. Open Settings on your Android phone
echo 2. Go to "About phone"
echo 3. Find "Build number"
echo 4. Tap "Build number" 7 times
echo 5. You'll see "You are now a developer!"
echo.
echo STEP 2: Enable USB Debugging
echo ----------------------------
echo 1. Go back to main Settings
echo 2. Look for "Developer options" or "System > Developer options"
echo 3. Enable "USB debugging"
echo 4. Enable "Install via USB" (if available)
echo.
echo STEP 3: Connect Device
echo ----------------------
echo 1. Connect phone to computer with USB cable
echo 2. On phone, you'll see "Allow USB debugging?" prompt
echo 3. Check "Always allow from this computer"
echo 4. Tap "OK" or "Allow"
echo.
echo STEP 4: Verify Connection
echo -------------------------
echo 1. Open command prompt
echo 2. Type: adb devices
echo 3. You should see your device listed
echo.
echo Run this script again and choose option 1 when device is connected.
echo.
pause
goto end

:end
echo.
echo Script finished.
pause
