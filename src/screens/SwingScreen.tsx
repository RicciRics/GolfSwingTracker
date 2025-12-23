/**
 * Swing Screen
 * Handles camera access, countdown, motion detection, and speed calculation
 */

import React, {useState, useEffect, useRef, useCallback} from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  Dimensions,
  Alert,
  Platform,
  PermissionsAndroid,
} from 'react-native';
import {
  Camera,
  useCameraDevice,
  useCameraPermission,
  useFrameProcessor,
} from 'react-native-vision-camera';
import {runOnJS} from 'react-native-reanimated';
import MotionDetector from '../utils/MotionDetector';

const {width, height} = Dimensions.get('window');

interface SwingScreenProps {
  onBack: () => void;
}

type SwingState = 'countdown' | 'detecting' | 'completed';

const SwingScreen: React.FC<SwingScreenProps> = ({onBack}) => {
  const [swingState, setSwingState] = useState<SwingState>('countdown');
  const [countdown, setCountdown] = useState(5);
  const [swingSpeed, setSwingSpeed] = useState<number | null>(null);
  const [isActive, setIsActive] = useState(true);
  
  const {hasPermission, requestPermission} = useCameraPermission();
  const device = useCameraDevice('front');
  
  const motionDetector = useRef(new MotionDetector()).current;
  const detectionStartTime = useRef<number>(0);

  // Request camera permissions on mount
  useEffect(() => {
    requestCameraPermission();
  }, []);

  const requestCameraPermission = async () => {
    if (Platform.OS === 'android') {
      try {
        const granted = await PermissionsAndroid.request(
          PermissionsAndroid.PERMISSIONS.CAMERA,
          {
            title: 'Camera Permission',
            message: 'Golf Swing Tracker needs access to your camera',
            buttonNeutral: 'Ask Me Later',
            buttonNegative: 'Cancel',
            buttonPositive: 'OK',
          },
        );
        if (granted !== PermissionsAndroid.RESULTS.GRANTED) {
          Alert.alert('Permission Denied', 'Camera access is required');
        }
      } catch (err) {
        console.warn(err);
      }
    } else {
      await requestPermission();
    }
  };

  // Countdown timer
  useEffect(() => {
    if (swingState === 'countdown' && countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    } else if (swingState === 'countdown' && countdown === 0) {
      // Start detection phase
      setSwingState('detecting');
      detectionStartTime.current = Date.now();
      motionDetector.reset();
    }
  }, [countdown, swingState]);

  // Auto-timeout for detection (10 seconds)
  useEffect(() => {
    if (swingState === 'detecting') {
      const timeout = setTimeout(() => {
        if (swingState === 'detecting') {
          handleSwingComplete(0); // No swing detected
        }
      }, 10000);
      return () => clearTimeout(timeout);
    }
  }, [swingState]);

  /**
   * Called when a swing is detected or timeout occurs
   * Calculates and displays the swing speed
   */
  const handleSwingComplete = useCallback((speed: number) => {
    if (swingState !== 'detecting') return;
    
    setSwingSpeed(speed);
    setSwingState('completed');
    setIsActive(false);
  }, [swingState]);

  /**
   * Frame processor for motion detection
   * Analyzes each camera frame to detect swing motion
   */
  const frameProcessor = useFrameProcessor(frame => {
    'worklet';
    
    if (swingState !== 'detecting') return;

    try {
      // Calculate motion intensity from frame
      const motionData = {
        timestamp: Date.now(),
        intensity: Math.random() * 0.3, // Placeholder - would analyze pixel differences
      };

      // Process motion on JS thread
      runOnJS(processMotion)(motionData);
    } catch (error) {
      console.log('Frame processing error:', error);
    }
  }, [swingState]);

  /**
   * Process motion data and detect swing
   * Uses motion detector to identify swing patterns
   */
  const processMotion = (motionData: {timestamp: number; intensity: number}) => {
    if (swingState !== 'detecting') return;

    const result = motionDetector.processFrame(motionData);
    
    if (result.swingDetected) {
      // Calculate speed based on motion intensity and duration
      const speed = result.calculatedSpeed;
      handleSwingComplete(speed);
    }
  };

  // Reset and go back to countdown
  const handleRetry = () => {
    setCountdown(5);
    setSwingState('countdown');
    setSwingSpeed(null);
    setIsActive(true);
    motionDetector.reset();
  };

  // Render different UI based on state
  const renderContent = () => {
    if (swingState === 'countdown') {
      return (
        <View style={styles.overlayContent}>
          <Text style={styles.countdownText}>{countdown}</Text>
          <Text style={styles.instructionText}>Get Ready...</Text>
        </View>
      );
    }

    if (swingState === 'detecting') {
      return (
        <View style={styles.overlayContent}>
          <View style={styles.detectingIndicator}>
            <Text style={styles.detectingText}>●</Text>
          </View>
          <Text style={styles.instructionText}>Swing Now!</Text>
          <Text style={styles.subInstructionText}>
            Detecting your swing...
          </Text>
        </View>
      );
    }

    if (swingState === 'completed') {
      return (
        <View style={styles.resultContainer}>
          <Text style={styles.resultLabel}>Club Speed</Text>
          <Text style={styles.speedValue}>
            {swingSpeed ? swingSpeed.toFixed(1) : '0.0'}
          </Text>
          <Text style={styles.speedUnit}>mph</Text>
          
          <View style={styles.buttonRow}>
            <TouchableOpacity
              style={[styles.actionButton, styles.retryButton]}
              onPress={handleRetry}>
              <Text style={styles.actionButtonText}>Try Again</Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[styles.actionButton, styles.homeButton]}
              onPress={onBack}>
              <Text style={styles.actionButtonText}>Home</Text>
            </TouchableOpacity>
          </View>
        </View>
      );
    }
  };

  if (!hasPermission) {
    return (
      <View style={styles.container}>
        <Text style={styles.permissionText}>
          Camera permission is required
        </Text>
        <TouchableOpacity style={styles.permissionButton} onPress={requestCameraPermission}>
          <Text style={styles.permissionButtonText}>Grant Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  if (!device) {
    return (
      <View style={styles.container}>
        <Text style={styles.permissionText}>No camera device found</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* Camera View */}
      {isActive && (
        <Camera
          style={StyleSheet.absoluteFill}
          device={device}
          isActive={isActive}
          frameProcessor={frameProcessor}
        />
      )}

      {/* Overlay */}
      <View style={styles.overlay}>{renderContent()}</View>

      {/* Back Button */}
      {swingState === 'countdown' && (
        <TouchableOpacity style={styles.backButton} onPress={onBack}>
          <Text style={styles.backButtonText}>← Back</Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a2e',
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(26, 26, 46, 0.7)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  overlayContent: {
    alignItems: 'center',
  },
  countdownText: {
    fontSize: 120,
    fontWeight: '700',
    color: '#00ff88',
    marginBottom: 20,
  },
  instructionText: {
    fontSize: 28,
    fontWeight: '600',
    color: '#ffffff',
    marginBottom: 10,
  },
  subInstructionText: {
    fontSize: 16,
    color: '#00ff88',
    marginTop: 10,
  },
  detectingIndicator: {
    marginBottom: 30,
  },
  detectingText: {
    fontSize: 60,
    color: '#ff0055',
    animation: 'pulse',
  },
  resultContainer: {
    alignItems: 'center',
    backgroundColor: '#16213e',
    padding: 40,
    borderRadius: 20,
    marginHorizontal: 30,
  },
  resultLabel: {
    fontSize: 20,
    color: '#00ff88',
    marginBottom: 10,
    fontWeight: '500',
  },
  speedValue: {
    fontSize: 80,
    fontWeight: '700',
    color: '#ffffff',
    marginVertical: 10,
  },
  speedUnit: {
    fontSize: 24,
    color: '#00ff88',
    marginBottom: 30,
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 15,
  },
  actionButton: {
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 25,
    minWidth: 120,
    alignItems: 'center',
  },
  retryButton: {
    backgroundColor: '#00ff88',
  },
  homeButton: {
    backgroundColor: '#16213e',
    borderWidth: 2,
    borderColor: '#00ff88',
  },
  actionButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1a1a2e',
  },
  backButton: {
    position: 'absolute',
    top: 50,
    left: 20,
    padding: 15,
  },
  backButtonText: {
    fontSize: 18,
    color: '#00ff88',
    fontWeight: '600',
  },
  permissionText: {
    fontSize: 18,
    color: '#ffffff',
    textAlign: 'center',
    marginTop: 100,
  },
  permissionButton: {
    backgroundColor: '#00ff88',
    marginHorizontal: 40,
    paddingVertical: 15,
    borderRadius: 25,
    alignItems: 'center',
    marginTop: 20,
  },
  permissionButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1a1a2e',
  },
});

export default SwingScreen;
