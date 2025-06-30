plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.events"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        // ⬇️ Enable API desugaring so Java 8+ libs will work on older runtimes
        isCoreLibraryDesugaringEnabled = true

        // Use Java 8 language level for desugared APIs
        sourceCompatibility = JavaVersion.VERSION_1_8  
        targetCompatibility = JavaVersion.VERSION_1_8  
    }

    kotlinOptions {
        // Match the desugared Java level
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.events"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // … your other dependencies …

    // This library provides the backport implementations of Java 8+ APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
}
