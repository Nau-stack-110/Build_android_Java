# __PROJECT_NAME__

Application Android native générée par `android-new`.

## Identité

- Package : `__PACKAGE__`
- minSdk : __MIN_SDK__
- targetSdk : __TARGET_SDK__
- compileSdk : __COMPILE_SDK__
- Build Tools : __BUILD_TOOLS__
- Langage : Java 17
- UI : Views/XML + Material3
- Build : Groovy DSL + AGP 8.6.1

## Prérequis

- JDK 17
- Android SDK API 35
- Build Tools 35.0.0
- Gradle 8.7
- adb (platform-tools)

## Compiler

```bash
gradle :app:assembleDebug
```

APK généré :

```text
app/build/outputs/apk/debug/app-debug.apk
```

Le wrapper `./gradlew` est inclus, mais le téléchargement de la distribution Gradle peut être bloqué selon le réseau. En cas d'échec, utiliser `gradle` installé sur la machine.

## Installer et lancer sur un téléphone

```bash
adb devices
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n __PACKAGE__/.MainActivity
adb logcat
```

## Structure

```text
app/src/main/
├── AndroidManifest.xml
├── java/__PACKAGE_PATH__/MainActivity.java
└── res/
    ├── drawable/
    │   ├── ic_launcher_background.xml
    │   └── ic_launcher_foreground.xml
    ├── layout/activity_main.xml
    ├── mipmap-anydpi-v26/
    │   ├── ic_launcher.xml
    │   └── ic_launcher_round.xml
    ├── mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/
    │   ├── ic_launcher.png
    │   └── ic_launcher_round.png
    ├── values/
    │   ├── colors.xml
    │   ├── strings.xml
    │   └── themes.xml
    ├── values-night/themes.xml
    └── xml/
        ├── backup_rules.xml
        └── data_extraction_rules.xml
```

## Drawables et icône

- `app/src/main/res/drawable/ic_launcher_background.xml`
- `app/src/main/res/drawable/ic_launcher_foreground.xml`
- `app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
- PNG de secours dans `app/src/main/res/mipmap-*/`

Pour remplacer l'icône, déposer un fichier dans `app/src/main/res/drawable/` puis référencer `@drawable/nom_du_fichier`. Les noms doivent être en minuscules, chiffres et underscores.

## Tests

Aucun fichier de test n'est inclus par défaut. Pour générer un nouveau projet avec les exemples de tests :

```bash
android-new MonApp com.naunau.monapp --with-tests
```

## VS Code

Extensions recommandées :

```bash
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-gradle
code --install-extension redhat.vscode-xml
code --install-extension adelphes.android-dev-ext
```

Tâches disponibles : `android: build debug`, `android: install debug`, `android: run`, `android: logcat`, `android: lint`, `android: clean`.
