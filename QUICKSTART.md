# Golf Swing Tracker - Quick Start Guide

## ⚡ Quick Installation (5 Minutes)

### Prerequisites Check
- [ ] Node.js 18+ installed
- [ ] Java JDK 17+ installed
- [ ] Android Studio installed with SDK
- [ ] Android device or emulator ready

### Installation Commands

```powershell
# 1. Install dependencies
cd C:\GolfSwingTracker
npm install

# 2. Connect your Android device (or start emulator)
adb devices

# 3. Run the app
npm run android
```

That's it! The app should launch on your device.

## 🎯 First Time Setup

### Android Studio Setup (One-time)
1. Download Android Studio: https://developer.android.com/studio
2. Install with default settings
3. Open Android Studio > SDK Manager
4. Install:
   - Android SDK Platform 34
   - Android SDK Build-Tools 34.0.0
   - Android SDK Platform-Tools

### Environment Variables (One-time)
Add to System Environment Variables:

**ANDROID_HOME**
```
C:\Users\YourUsername\AppData\Local\Android\Sdk
```

**JAVA_HOME**
```
C:\Program Files\Java\jdk-17
```

**PATH** (add these lines):
```
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
%JAVA_HOME%\bin
```

### Verify Installation
```powershell
node --version    # Should show v18.x or higher
java -version     # Should show version 17 or higher
adb version       # Should show Android Debug Bridge version
```

## 📱 Running on Physical Device

1. **Enable Developer Mode**
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Developer Options now enabled

2. **Enable USB Debugging**
   - Settings > Developer Options
   - Enable "USB Debugging"

3. **Connect Device**
   - Connect via USB cable
   - Accept debugging prompt on phone
   - Run: `adb devices` (should show your device)

4. **Launch App**
   ```powershell
   npm run android
   ```

## 🖥️ Running on Emulator

1. **Create Emulator**
   - Open Android Studio
   - Tools > AVD Manager
   - Create Virtual Device
   - Choose: Pixel 5 or similar
   - System Image: Android 11+ (API 30+)
   - Finish and launch

2. **Verify Emulator**
   ```powershell
   adb devices
   # Should show: emulator-5554    device
   ```

3. **Launch App**
   ```powershell
   npm run android
   ```

## 🔧 Common Issues & Fixes

### Issue: "Command not found: adb"
**Fix**: Add Android SDK to PATH (see Environment Variables above)

### Issue: "No devices found"
**Fix**: 
- Physical: Check USB cable, enable USB debugging
- Emulator: Launch from Android Studio AVD Manager

### Issue: "Metro bundler port already in use"
**Fix**:
```powershell
# Kill existing Metro process
Get-Process node | Stop-Process
npm start
```

### Issue: Build fails with Gradle error
**Fix**:
```powershell
cd android
.\gradlew clean
cd ..
npm run android
```

### Issue: Camera permission denied
**Fix**:
- Go to device Settings > Apps > Golf Swing Tracker > Permissions
- Enable Camera permission manually

## 🎮 Using the App

1. **Launch**: Open "Golf Swing Tracker"
2. **Start**: Tap "Start Swing" button
3. **Prepare**: 5-second countdown begins
4. **Position**: 
   - Stand 3-5 feet from phone
   - Face the front camera
   - Ensure full swing will be visible
5. **Swing**: Make your golf swing when countdown ends
6. **Results**: View your club speed in mph
7. **Retry**: Tap "Try Again" for another attempt

## 📊 Expected Results

- **Typical Speeds**:
  - Beginner: 60-75 mph
  - Intermediate: 75-90 mph
  - Advanced: 90-105 mph
  - Professional: 105-125 mph

## 💡 Pro Tips

1. **Lighting**: Use good, even lighting
2. **Background**: Stand in front of plain wall
3. **Distance**: 3-5 feet from camera optimal
4. **Angle**: Camera should capture full swing arc
5. **Stability**: Mount phone on stable surface
6. **Practice**: First few swings are for calibration

## 📞 Need Help?

1. Read the full README.md for detailed instructions
2. Check troubleshooting section
3. Verify all prerequisites are installed
4. Make sure device is properly connected

---

**Ready to Track Your Swing!** 🏌️‍♂️⛳
