# Proguard configuration for 16 KB page size support
# Google Play Console compliance for Android 15+ (API 35+)

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Keep Google Play Core classes for deferred components
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# 16 KB page size optimization rules
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-dontobfuscate

# Memory alignment optimizations for 16 KB pages
-keepattributes Signature,RuntimeVisibleAnnotations,AnnotationDefault

# Keep native methods for 16 KB page size compatibility
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve memory layout for 16 KB page size support
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Additional rules for Flutter plugins
-keep class com.google.** { *; }
-keep class androidx.lifecycle.** { *; }

# Kootumb app specific rules
-keep class social.kongo.kootumb_app.** { *; }

# Flutter deferred components support
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Prevent R8 from removing Play Core classes
-if class com.google.android.play.core.splitcompat.SplitCompatApplication
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }

-if class com.google.android.play.core.splitinstall.**
-keep class com.google.android.play.core.splitinstall.** { *; }

# 16 KB page size specific optimizations
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}
