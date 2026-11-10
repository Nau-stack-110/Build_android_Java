# Dépannage

## Vérifier l'environnement

```bash
java -version
gradle --version
echo "$ANDROID_HOME"
adb version
android-new --help
```

## Générateur

### `android-new: command not found`

```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc
```

### `gradle introuvable`

Installer Gradle 8.7 et l'ajouter au `PATH`.

```bash
export PATH="$HOME/.local/opt/gradle-8.7/bin:$PATH"
```

### `SDK Android introuvable`

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
```

### `JDK introuvable`

```bash
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
```

Utiliser un JDK complet, pas un JRE.

### `template introuvable`

Copier tout le dossier `android-scaffold`.
Le script seul ne suffit pas.

### `le dossier existe déjà`

Choisir un autre nom ou un autre `--output`.

### `package invalide`

Utiliser des minuscules avec au moins deux parties :

```text
com.naunau.monapp
```

## Build

### `SDK location not found`

Vérifier `local.properties` :

```properties
sdk.dir=/home/user/Android/Sdk
```

### `Failed to find Build Tools revision 35.0.0`

```bash
sdkmanager --sdk_root="$ANDROID_HOME" "build-tools;35.0.0"
```

### `Failed to find target android-35`

```bash
sdkmanager --sdk_root="$ANDROID_HOME" "platforms;android-35"
```

### `Android Gradle plugin requires Java 17`

Utiliser JDK 17 :

```bash
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
```

### Wrapper Gradle bloqué

Utiliser Gradle système :

```bash
gradle :app:assembleDebug
```

### `Could not resolve ...`

Vérifier le réseau, le proxy ou le DNS.

## Téléphone

### `adb: no devices/emulators found`

- Activer le débogage USB.
- Autoriser l'ordinateur.
- Vérifier :

```bash
adb devices
```

### `unauthorized`

Débrancher, rebrancher, accepter la demande sur le téléphone.

### `INSTALL_FAILED_UPDATE_INCOMPATIBLE`

```bash
adb uninstall com.naunau.monapp
```

Cela supprime les données de l'application.

## VS Code

### Extensions Java/XML absentes

Le build fonctionne sans elles.

```bash
code --install-extension vscjava.vscode-java-pack
code --install-extension redhat.vscode-xml
```

### Import Gradle incorrect

Corriger `java.import.gradle.home` dans `.vscode/settings.json`.

## Nettoyer

```bash
gradle clean
rm -rf .gradle build app/build
```
