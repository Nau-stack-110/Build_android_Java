# Installation Linux

Objectif : installer `android-new` sans Android Studio.

## 1. Paquets de base

Debian / Ubuntu / Parrot :

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk python3 git curl unzip tar
```

Autres distributions : adapter les noms de paquets.

## 2. JDK 17

```bash
java -version
javac -version
```

Les deux doivent indiquer `17`.

Trouver `JAVA_HOME` :

```bash
readlink -f "$(command -v java)"
```

Exemple :

```text
/usr/lib/jvm/java-17-openjdk-amd64/bin/java
```

Ajouter dans `~/.zshrc` ou `~/.bashrc` :

```bash
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
```

## 3. SDK Android

Créer le dossier :

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
mkdir -p "$ANDROID_HOME/cmdline-tools"
```

Télécharger les command-line tools :

<https://developer.android.com/studio#command-tools>

Choisir « Command line tools only » pour Linux.

Installer :

```bash
# Se placer dans le dossier de téléchargement
rm -rf /tmp/cmdline-tools
unzip commandlinetools-linux-*_latest.zip -d /tmp
mv /tmp/cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
```

Configurer :

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
```

Accepter les licences :

```bash
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses
```

Installer les paquets :

```bash
sdkmanager --sdk_root="$ANDROID_HOME" \
  "platform-tools" \
  "platforms;android-35" \
  "build-tools;35.0.0"
```

Vérifier :

```bash
adb version
```

## 4. Gradle 8.7

```bash
mkdir -p "$HOME/.local/opt"
curl -fL -o /tmp/gradle-8.7-bin.zip \
  https://services.gradle.org/distributions/gradle-8.7-bin.zip
unzip -q -o /tmp/gradle-8.7-bin.zip -d "$HOME/.local/opt"
```

Ajouter :

```bash
export GRADLE_HOME="$HOME/.local/opt/gradle-8.7"
export PATH="$GRADLE_HOME/bin:$PATH"
```

Vérifier :

```bash
gradle --version
```

Utiliser le vrai dossier Gradle, pas un symlink.

## 5. Générateur

Cloner tout le dépôt :

```bash
git clone https://github.com/Nau-stack-110/Build_android_Java.git \
  "$HOME/build_android_java"
chmod +x "$HOME/build_android_java/new-project.sh"
chmod +x "$HOME/build_android_java/template/gradlew"
```

Créer la commande :

```bash
mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/build_android_java/new-project.sh" \
        "$HOME/.local/bin/android-new"
export PATH="$HOME/.local/bin:$PATH"
```

## 6. Shell

`JAVA_HOME`, `ANDROID_HOME` et `PATH` indiquent où sont les outils.

Ajouter dans `~/.zshrc` ou `~/.bashrc` :

```bash
# JDK
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Gradle
export GRADLE_HOME="$HOME/.local/opt/gradle-8.7"
export PATH="$GRADLE_HOME/bin:$PATH"

# Commandes locales
export PATH="$HOME/.local/bin:$PATH"
```

Recharger :

```bash
source ~/.zshrc
```

## 7. Vérifier

```bash
java -version
gradle --version
sdkmanager --version
adb version
android-new --help
```

## 8. Premier projet

```bash
android-new TestApp com.example.testapp --output "$HOME/AndroidProjects"
cd "$HOME/AndroidProjects/TestApp"
gradle :app:assembleDebug
```

APK :

```text
app/build/outputs/apk/debug/app-debug.apk
```

En cas d'erreur : [TROUBLESHOOTING.md](TROUBLESHOOTING.md).
