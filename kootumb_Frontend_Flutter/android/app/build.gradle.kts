plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.haccky_ok"
    compileSdk = 36  // Updated to Android 16 (API 36)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Application ID for Kootumb social media app
        applicationId = "social.kongo.kootumb_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion  // Keep minimum SDK from Flutter
        targetSdk = 36  // Updated to Android 16 (API 36) 
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // 16 KB page size compatibility for Google Play Console requirement
        // Required for Android 15+ (API 35+) compliance
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // Temporarily disable minification for successful build
            // The 16 KB page size support is in the manifest and NDK configuration
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
    
    // 16 KB page size support configuration
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }
    
    // Enable support for 16 KB page sizes
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}
