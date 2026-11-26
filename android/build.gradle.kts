group = "com.suryakaranr.label_flutter_plugin"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.4.0"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

// The Label SDK AAR (com.suryakaranr:labelsdk) ships inside this plugin as a
// folder Maven repository, published from the label-android-sdk repo.
// The app resolves this plugin's dependencies, so the folder is added to every
// project of the app's build.
val labelSdkRepo = file("libs/maven")
rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri(labelSdkRepo) }
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "com.suryakaranr.label_flutter_plugin"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation("com.suryakaranr:labelsdk:1.1.0")
}
