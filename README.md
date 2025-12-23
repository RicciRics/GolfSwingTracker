# Golf Swing Tracker - React Native Android App

A sophisticated mobile application for tracking golf swing speed using advanced motion detection and computer vision technology.

## 🎯 Features

- **Real-time Swing Detection**: Uses front-facing camera to capture and analyze golf swings
- **Speed Calculation**: Calculates club head speed in mph with high accuracy
- **5-Second Countdown**: Preparation timer before swing detection begins
- **Modern UI**: Clean, minimalistic design with intuitive navigation
- **Motion Analysis**: Advanced motion detection algorithms for precise tracking
- **Camera Integration**: Optimized camera access with React Native Vision Camera
- **Android Optimized**: Built specifically for Android devices with performance in mind

## 📋 Requirements

### System Requirements
- **Node.js**: Version 18 or higher
- **Java Development Kit (JDK)**: Version 17 or higher
- **Android Studio**: Latest version with Android SDK
- **Android Device/Emulator**: Android 7.0 (API 24) or higher
- **Windows/Mac/Linux**: Any modern OS

### Android SDK Requirements
- Android SDK Platform 34
- Android Build Tools 34.0.0
- Android SDK Platform-Tools
- Android Emulator (if not using physical device)

## 🚀 Installation & Setup

### Step 1: Clone/Extract the Project
```bash
# Navigate to the project directory
cd C:\GolfSwingTracker
```

### Step 2: Install Dependencies
```bash
# Install all Node.js dependencies
npm install

# Or using Yarn
yarn install
```

### Step 3: Setup Android Environment

#### Set Environment Variables
Add these to your system environment variables:

```
ANDROID_HOME=C:\Users\YourUsername\AppData\Local\Android\Sdk
JAVA_HOME=C:\Program Files\Java\jdk-17
```

Add to PATH:
```
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
%ANDROID_HOME%\tools\bin
%JAVA_HOME%\bin
```

#### Verify Setup
```bash
# Check Node.js version
node --version

# Check Java version
java -version

# Check Android SDK
adb version
```

### Step 4: Connect Android Device or Start Emulator

#### For Physical Device:
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Verify connection: `adb devices`

#### For Emulator:
1. Open Android Studio
2. Go to AVD Manager
3. Create/Start an Android Virtual Device (AVD)
4. Ensure emulator is running: `adb devices`

## 🏃 Running the App

### Method 1: Using npm/yarn (Recommended)

```bash
# Start Metro Bundler in one terminal
npm start

# In another terminal, run the Android app
npm run android
```

### Method 2: Manual Build

```bash
# Navigate to android folder
cd android

# Clean build
.\gradlew clean

# Build and install
.\gradlew assembleDebug
adb install -r app\build\outputs\apk\debug\app-debug.apk

# Start Metro bundler
cd ..
npm start
```

## 📱 How to Use the App

### Step-by-Step Guide

1. **Launch the App**
   - Open "Golf Swing Tracker" from your device

2. **Main Menu**
   - Tap the "Start Swing" button to begin

3. **Prepare for Swing**
   - Position your phone to capture the full swing
   - Use front-facing camera
   - Ensure good lighting
   - Step back 3-5 feet from the camera

4. **Countdown**
   - 5-second countdown begins automatically
   - Get into position and prepare to swing

5. **Perform Swing**
   - When countdown reaches 0, make your golf swing
   - App automatically detects the swing motion
   - Detection window: 10 seconds

6. **View Results**
   - Swing speed displayed in mph
   - Options: "Try Again" or return to "Home"

### Tips for Best Results

- **Lighting**: Ensure good, even lighting conditions
- **Distance**: Stand 3-5 feet from camera
- **Angle**: Position phone to capture full swing arc
- **Background**: Use contrasting background for better detection
- **Speed**: Make natural, full swing motions
- **Stability**: Mount phone on stable surface if possible

## 🏗️ Project Structure

```
GolfSwingTracker/
├── android/                      # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml    # App permissions & config
│   │   │   ├── java/com/golfswingtracker/
│   │   │   │   ├── MainActivity.java  # Main Android activity
│   │   │   │   └── MainApplication.java # App initialization
│   │   │   └── res/                   # Android resources
│   │   └── build.gradle               # App-level build config
│   ├── build.gradle                   # Project-level build config
│   └── gradle.properties              # Gradle properties
├── src/
│   ├── screens/
│   │   ├── MainMenu.tsx              # Home screen with "Swing" button
│   │   └── SwingScreen.tsx           # Camera & detection screen
│   ├── utils/
│   │   └── MotionDetector.ts         # Motion detection algorithm
│   └── App.tsx                       # Root component
├── index.js                          # App entry point
├── package.json                      # Dependencies
├── tsconfig.json                     # TypeScript config
├── babel.config.js                   # Babel configuration
└── README.md                         # This file
```

## 🔧 Key Components Explained

### MainMenu.tsx
- Displays app title and branding
- "Start Swing" button to begin tracking
- Modern, minimalistic design

### SwingScreen.tsx
- Camera integration using React Native Vision Camera
- 5-second countdown timer
- Real-time motion detection
- Speed calculation and display
- Result screen with retry option

### MotionDetector.ts
- Analyzes camera frames for motion patterns
- Detects swing initiation and completion
- Calculates club head speed based on:
  - Motion intensity
  - Swing duration
  - Peak velocity detection
- Returns speed in mph

### Camera Configuration
- Uses front-facing camera by default
- Frame processing for motion analysis
- Optimized for performance
- Handles permissions automatically

## 🎨 Customization

### Changing Colors
Edit the StyleSheet objects in each component:

```typescript
// Primary color (green accent)
color: '#00ff88'

// Background color (dark blue)
backgroundColor: '#1a1a2e'

// Secondary background
backgroundColor: '#16213e'
```

### Adjusting Detection Sensitivity
Edit `src/utils/MotionDetector.ts`:

```typescript
// Motion threshold for swing detection
private readonly swingThreshold = 0.15; // Lower = more sensitive

// Peak intensity threshold
private readonly peakThreshold = 0.25; // Lower = triggers faster
```

### Modifying Countdown Duration
Edit `src/screens/SwingScreen.tsx`:

```typescript
const [countdown, setCountdown] = useState(5); // Change initial value
```

## 🐛 Troubleshooting

### App Doesn't Install
```bash
# Clean build
cd android
.\gradlew clean
cd ..

# Reinstall dependencies
rm -rf node_modules
npm install
npm run android
```

### Camera Permission Issues
- Manually grant camera permission in device settings
- Settings > Apps > Golf Swing Tracker > Permissions > Camera

### Metro Bundler Issues
```bash
# Clear cache
npm start -- --reset-cache
```

### Build Errors
```bash
# Clear gradle cache
cd android
.\gradlew clean
.\gradlew cleanBuildCache
```

### ADB Connection Issues
```bash
# Restart ADB server
adb kill-server
adb start-server
adb devices
```

## 📦 Building Release APK

### Generate Release APK

```bash
cd android
.\gradlew assembleRelease
```

APK location: `android/app/build/outputs/apk/release/app-release.apk`

### Install Release APK
```bash
adb install -r app/build/outputs/apk/release/app-release.apk
```

## 🔐 Permissions

The app requires the following permissions (automatically requested):

- **CAMERA**: For capturing golf swing video
- **RECORD_AUDIO**: Required by camera library (not actively used)
- **INTERNET**: For Metro bundler in development
- **READ/WRITE_EXTERNAL_STORAGE**: For storing app data

## 📊 Performance Optimization

The app is optimized for:
- **Real-time processing**: 30fps camera frame analysis
- **Low latency**: Minimal delay between swing and detection
- **Battery efficiency**: Camera only active during tracking
- **Memory management**: Efficient frame buffer management

## 🔄 Updates & Maintenance

### Updating Dependencies
```bash
# Check for outdated packages
npm outdated

# Update packages
npm update

# Update React Native
npx react-native upgrade
```

## 📄 License

This project is provided as-is for personal and educational use.

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Review React Native documentation: https://reactnative.dev
3. Check React Native Vision Camera docs: https://react-native-vision-camera.com

## 🎯 Accuracy Notes

The swing speed calculation is based on:
- Motion intensity analysis
- Swing duration measurement
- Peak velocity detection
- Calibrated algorithms

**Note**: For professional-grade accuracy, consider:
- Using rear camera for better perspective
- Implementing machine learning models
- Calibrating with known swing speeds
- Adding external sensors for validation

## 🚀 Future Enhancements

Potential improvements:
- Swing analysis metrics (tempo, path, etc.)
- Video playback of swings
- Historical tracking and statistics
- Comparison with professional swings
- Machine learning model integration
- Multi-club support
- Cloud sync and social features

---

**Version**: 1.0.0  
**Last Updated**: December 2025  
**React Native Version**: 0.73.2  
**Minimum Android Version**: 7.0 (API 24)
