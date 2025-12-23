# Android ProGuard Rules for Golf Swing Tracker

# Keep React Native and JavaScript core
-keep class com.facebook.react.** { *; }
-keep class com.facebook.hermes.** { *; }

# Keep camera related classes
-keep class com.mrousavy.camera.** { *; }

# Keep TensorFlow Lite classes
-keep class org.tensorflow.** { *; }

# General Android rules
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
