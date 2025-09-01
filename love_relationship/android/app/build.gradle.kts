import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")        // <- em Kotlin DSL é este id (não "kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")   
}

dependencies {
  implementation(platform("com.google.firebase:firebase-bom:34.0.0"))
  implementation("com.google.firebase:firebase-analytics")
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

val localProperties = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

val flutterVersionCode: Int =
    (localProperties.getProperty("flutter.versionCode") ?: "1").toInt()

val flutterVersionName: String =
    localProperties.getProperty("flutter.versionName") ?: "5.0.0"

// ---- key.properties ----
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) FileInputStream(f).use { load(it) }
}

android {
    namespace = "com.always.about.love.love_relationship"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true

        kotlinOptions { jvmTarget = "17" }
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.always.about.love.love_relationship"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion.toInt()
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

        signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties["storeFile"]?.toString()
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
                storePassword = keystoreProperties["storePassword"]?.toString()
                keyAlias = keystoreProperties["keyAlias"]?.toString()
                keyPassword = keystoreProperties["keyPassword"]?.toString()
            }
        }
    }

    buildTypes {

        // debug sempre sem shrink
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        // release sem shrink por enquanto (mais simples p/ rodar)
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.findByName("release")
        }

        // Flutter costuma ter o buildType "profile"; garanta que também não encolha:
        val profile = this.findByName("profile") ?: this.create("profile")
        profile.apply {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
