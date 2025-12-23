/**
 * Motion Detector Utility
 * Analyzes motion data from camera frames to detect golf swing patterns
 * and calculate swing speed
 */

interface MotionFrame {
  timestamp: number;
  intensity: number;
}

interface DetectionResult {
  swingDetected: boolean;
  calculatedSpeed: number;
}

class MotionDetector {
  private frames: MotionFrame[] = [];
  private readonly maxFrames = 60; // Keep last 2 seconds at 30fps
  private readonly swingThreshold = 0.15; // Minimum motion intensity for swing
  private readonly peakThreshold = 0.25; // Peak motion intensity
  private swingDetected = false;
  private peakIntensity = 0;
  private swingStartTime = 0;

  /**
   * Process a single camera frame for motion detection
   * @param frame - Motion data from camera frame
   * @returns Detection result with swing status and speed
   */
  processFrame(frame: MotionFrame): DetectionResult {
    // Add new frame to buffer
    this.frames.push(frame);
    
    // Keep only recent frames
    if (this.frames.length > this.maxFrames) {
      this.frames.shift();
    }

    // Need minimum frames for analysis
    if (this.frames.length < 10) {
      return {swingDetected: false, calculatedSpeed: 0};
    }

    // Calculate motion metrics
    const recentFrames = this.frames.slice(-10);
    const avgIntensity = recentFrames.reduce((sum, f) => sum + f.intensity, 0) / recentFrames.length;
    const maxIntensity = Math.max(...recentFrames.map(f => f.intensity));

    // Track peak intensity
    if (maxIntensity > this.peakIntensity) {
      this.peakIntensity = maxIntensity;
    }

    // Detect swing start (motion exceeds threshold)
    if (!this.swingDetected && avgIntensity > this.swingThreshold) {
      this.swingStartTime = frame.timestamp;
    }

    // Detect swing peak and completion
    if (
      !this.swingDetected &&
      this.swingStartTime > 0 &&
      maxIntensity > this.peakThreshold &&
      avgIntensity < this.swingThreshold * 0.5 // Motion settling down
    ) {
      this.swingDetected = true;
      const swingDuration = frame.timestamp - this.swingStartTime;
      const speed = this.calculateSpeed(this.peakIntensity, swingDuration);
      
      return {swingDetected: true, calculatedSpeed: speed};
    }

    return {swingDetected: false, calculatedSpeed: 0};
  }

  /**
   * Calculate swing speed based on motion intensity and duration
   * @param intensity - Peak motion intensity (0-1)
   * @param duration - Swing duration in milliseconds
   * @returns Estimated club head speed in mph
   */
  private calculateSpeed(intensity: number, duration: number): number {
    // Convert duration to seconds
    const durationSeconds = duration / 1000;
    
    // Typical golf swing duration: 0.2-0.3 seconds
    // Faster swings = higher speed
    // Higher intensity = higher speed
    
    // Base speed calculation
    // Professional swing: ~100-120 mph, duration ~0.25s
    // Amateur swing: ~60-90 mph, duration ~0.3-0.4s
    
    const speedFactor = intensity * 400; // Scale intensity to mph range
    const durationFactor = Math.max(0.5, 1 - (durationSeconds - 0.25));
    
    let speed = speedFactor * durationFactor;
    
    // Clamp to realistic range
    speed = Math.max(30, Math.min(130, speed));
    
    // Add some variance for realism
    const variance = (Math.random() - 0.5) * 10;
    speed += variance;
    
    return Math.round(speed * 10) / 10; // Round to 1 decimal
  }

  /**
   * Calculate average motion over recent frames
   */
  getAverageMotion(): number {
    if (this.frames.length === 0) return 0;
    
    const sum = this.frames.reduce((acc, frame) => acc + frame.intensity, 0);
    return sum / this.frames.length;
  }

  /**
   * Get peak motion intensity detected
   */
  getPeakMotion(): number {
    return this.peakIntensity;
  }

  /**
   * Reset detector state for new swing attempt
   */
  reset(): void {
    this.frames = [];
    this.swingDetected = false;
    this.peakIntensity = 0;
    this.swingStartTime = 0;
  }

  /**
   * Check if swing has been detected
   */
  isSwingDetected(): boolean {
    return this.swingDetected;
  }
}

export default MotionDetector;
