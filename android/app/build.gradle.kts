plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Use the highest NDK required by plugins
    ndkVersion = "27.0.12077973"

    namespace = "com.example.id_search"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.id_search"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Keep your signing config as you had it
            signingConfig = signingConfigs.getByName("debug")

            // Keep minification enabled for release (R8). If you want to debug builds without minification,
            // temporarily set isMinifyEnabled = false while fixing R8 issues.
            isMinifyEnabled = true

            // Include default proguard + your rules + the R8-generated missing_rules if present
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
                file("build/outputs/mapping/release/missing_rules.txt")
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Keep your existing dependencies (the Flutter plugin will add most Android libs).
    // Add annotation libraries referenced by the error messages so R8 can resolve them at compile time.
    implementation("com.google.errorprone:error_prone_annotations:2.20.0")
    implementation("javax.annotation:javax.annotation-api:1.3.2")
    implementation("com.google.code.findbugs:jsr305:3.0.2")
}