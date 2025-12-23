# Generate APK and QR Code for Installation
# This script builds the APK and creates a QR code for easy phone installation

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Golf Swing Tracker - APK Builder & QR Generator" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Android SDK is available
try {
    $null = Get-Command adb -ErrorAction Stop
} catch {
    Write-Host "[ERROR] Android SDK not found!" -ForegroundColor Red
    Write-Host "Please install Android Studio first." -ForegroundColor Yellow
    Write-Host "Run INSTALL.bat or INSTALL.ps1 for setup instructions." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Set-Location $PSScriptRoot

Write-Host "Choose build type:" -ForegroundColor Yellow
Write-Host "1. Debug APK (faster, larger file ~50MB)" -ForegroundColor White
Write-Host "2. Release APK (optimized, smaller ~30MB)" -ForegroundColor White
Write-Host ""
$buildType = Read-Host "Enter choice (1 or 2)"

$apkPath = ""
$buildCommand = ""

if ($buildType -eq "1") {
    Write-Host ""
    Write-Host "Building DEBUG APK..." -ForegroundColor Cyan
    $buildCommand = "assembleDebug"
    $apkPath = "android\app\build\outputs\apk\debug\app-debug.apk"
} else {
    Write-Host ""
    Write-Host "Building RELEASE APK..." -ForegroundColor Cyan
    $buildCommand = "assembleRelease"
    $apkPath = "android\app\build\outputs\apk\release\app-release.apk"
}

Write-Host ""
Write-Host "Step 1: Installing dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] npm install failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 2: Building APK (this may take 5-10 minutes)..." -ForegroundColor Yellow
Write-Host "Please wait..." -ForegroundColor Gray
Write-Host ""

Set-Location android
.\gradlew $buildCommand
$buildSuccess = $LASTEXITCODE -eq 0
Set-Location ..

if (-not $buildSuccess) {
    Write-Host ""
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

if (-not (Test-Path $apkPath)) {
    Write-Host ""
    Write-Host "[ERROR] APK file not found at: $apkPath" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  SUCCESS! APK Built Successfully" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Copy APK to convenient location
$desktopPath = [Environment]::GetFolderPath("Desktop")
$apkFileName = Split-Path $apkPath -Leaf
$destinationPath = Join-Path $desktopPath $apkFileName

Copy-Item $apkPath $destinationPath -Force
Write-Host "APK copied to: $destinationPath" -ForegroundColor Cyan

# Get file size
$fileSize = (Get-Item $destinationPath).Length / 1MB
Write-Host "APK Size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Cyan
Write-Host ""

# Installation options
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "  Installation Options" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "Option 1: Install via USB (Recommended)" -ForegroundColor White
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "Connect your phone and run:" -ForegroundColor White
Write-Host "  adb install -r `"$destinationPath`"" -ForegroundColor Green
Write-Host ""

Write-Host "Option 2: Transfer APK to Phone" -ForegroundColor White
Write-Host "--------------------------------" -ForegroundColor Gray
Write-Host "a) Email the APK to yourself" -ForegroundColor White
Write-Host "b) Upload to Google Drive/Dropbox" -ForegroundColor White
Write-Host "c) Transfer via USB cable to phone storage" -ForegroundColor White
Write-Host "d) Use a file transfer app" -ForegroundColor White
Write-Host ""
Write-Host "Then on phone:" -ForegroundColor White
Write-Host "1. Open the APK file" -ForegroundColor Gray
Write-Host "2. Allow 'Install from unknown sources' if prompted" -ForegroundColor Gray
Write-Host "3. Tap 'Install'" -ForegroundColor Gray
Write-Host ""

Write-Host "Option 3: Generate QR Code Link" -ForegroundColor White
Write-Host "-------------------------------" -ForegroundColor Gray
Write-Host "To create a scannable QR code:" -ForegroundColor White
Write-Host ""
Write-Host "1. Upload APK to a file hosting service:" -ForegroundColor White
Write-Host "   - Google Drive (get shareable link)" -ForegroundColor Gray
Write-Host "   - Dropbox (get public link)" -ForegroundColor Gray
Write-Host "   - GitHub Releases" -ForegroundColor Gray
Write-Host "   - Any file hosting service" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Get the direct download link" -ForegroundColor White
Write-Host ""
Write-Host "3. Create QR code from link using:" -ForegroundColor White
Write-Host "   - https://qr-code-generator.com" -ForegroundColor Gray
Write-Host "   - https://www.qr-code-generator.com" -ForegroundColor Gray
Write-Host "   - Any QR code generator website" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Print or display QR code" -ForegroundColor White
Write-Host "5. Scan with phone camera to download & install" -ForegroundColor White
Write-Host ""

# Try to create QR code if qrcode module is available
Write-Host "Attempting to generate QR code locally..." -ForegroundColor Yellow
Write-Host ""

# Create simple HTML page with QR code generator
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Golf Swing Tracker - QR Code Generator</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
        }
        .container {
            background: #16213e;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,255,136,0.3);
            border: 2px solid #00ff88;
        }
        h1 {
            color: #00ff88;
            text-align: center;
        }
        .input-group {
            margin: 20px 0;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #00ff88;
        }
        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #00ff88;
            border-radius: 5px;
            background: #1a1a2e;
            color: white;
            font-size: 14px;
        }
        button {
            background: #00ff88;
            color: #1a1a2e;
            border: none;
            padding: 15px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
            margin-top: 10px;
        }
        button:hover {
            background: #00dd77;
        }
        #qrcode {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background: white;
            border-radius: 10px;
            display: none;
        }
        .instructions {
            background: #1a1a2e;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .step {
            margin: 10px 0;
            padding-left: 20px;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
</head>
<body>
    <div class="container">
        <h1>⛳ Golf Swing Tracker</h1>
        <h2 style="text-align: center; color: white;">QR Code Generator</h2>
        
        <div class="instructions">
            <h3 style="color: #00ff88;">📋 Instructions:</h3>
            <div class="step">1. Upload your APK file to a hosting service (Google Drive, Dropbox, etc.)</div>
            <div class="step">2. Get the direct download link</div>
            <div class="step">3. Paste the link below</div>
            <div class="step">4. Click "Generate QR Code"</div>
            <div class="step">5. Scan with your phone to download</div>
        </div>
        
        <div class="input-group">
            <label for="apkUrl">APK Download Link:</label>
            <input type="url" id="apkUrl" placeholder="https://example.com/golf-swing-tracker.apk" />
        </div>
        
        <button onclick="generateQR()">Generate QR Code</button>
        
        <div id="qrcode"></div>
        
        <div class="instructions" style="margin-top: 30px;">
            <h3 style="color: #00ff88;">📱 How to Install on Phone:</h3>
            <div class="step">1. Open camera app on your Android phone</div>
            <div class="step">2. Point camera at the QR code</div>
            <div class="step">3. Tap the notification to open download link</div>
            <div class="step">4. Download the APK file</div>
            <div class="step">5. Open the downloaded file</div>
            <div class="step">6. Allow "Install from unknown sources" if prompted</div>
            <div class="step">7. Tap "Install"</div>
            <div class="step">8. Open "Golf Swing Tracker" app</div>
        </div>
        
        <div class="instructions" style="margin-top: 30px; background: #00ff88; color: #1a1a2e;">
            <h3>📍 Current APK Location:</h3>
            <div class="step" style="word-break: break-all;">$destinationPath</div>
        </div>
    </div>
    
    <script>
        function generateQR() {
            const url = document.getElementById('apkUrl').value;
            if (!url) {
                alert('Please enter a download link!');
                return;
            }
            
            const qrcodeDiv = document.getElementById('qrcode');
            qrcodeDiv.innerHTML = '';
            qrcodeDiv.style.display = 'block';
            
            new QRCode(qrcodeDiv, {
                text: url,
                width: 300,
                height: 300,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            });
            
            // Add download button
            setTimeout(() => {
                const downloadBtn = document.createElement('button');
                downloadBtn.textContent = 'Download QR Code Image';
                downloadBtn.style.marginTop = '20px';
                downloadBtn.onclick = function() {
                    const canvas = qrcodeDiv.querySelector('canvas');
                    const link = document.createElement('a');
                    link.download = 'golf-swing-tracker-qr.png';
                    link.href = canvas.toDataURL();
                    link.click();
                };
                qrcodeDiv.appendChild(downloadBtn);
            }, 100);
        }
    </script>
</body>
</html>
"@

$htmlPath = Join-Path $desktopPath "GolfSwingTracker-QRGenerator.html"
$htmlContent | Out-File -FilePath $htmlPath -Encoding UTF8

Write-Host "QR Code Generator created: $htmlPath" -ForegroundColor Green
Write-Host ""
Write-Host "Opening QR Code Generator in browser..." -ForegroundColor Cyan
Start-Process $htmlPath

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  Quick Install via USB" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
$install = Read-Host "Do you want to install on connected device now? (Y/N)"

if ($install -eq "Y" -or $install -eq "y") {
    Write-Host ""
    Write-Host "Checking for connected devices..." -ForegroundColor Yellow
    adb devices
    Write-Host ""
    Write-Host "Installing APK..." -ForegroundColor Yellow
    adb install -r $destinationPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! App installed on device!" -ForegroundColor Green
        Write-Host "Open 'Golf Swing Tracker' on your phone to use it." -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "Installation failed. Make sure device is connected." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "✅ APK built successfully" -ForegroundColor Green
Write-Host "✅ APK saved to Desktop: $apkFileName" -ForegroundColor Green
Write-Host "✅ QR Code Generator created" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Upload APK to file hosting service" -ForegroundColor White
Write-Host "2. Use QR Generator HTML to create scannable code" -ForegroundColor White
Write-Host "3. Scan QR with phone to download & install" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
