allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Diretório de build no root do projeto (onde o Flutter espera encontrar o APK)
rootProject.layout.buildDirectory.set(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    val newSubprojectBuildDir = rootProject.layout.buildDirectory.get().dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

