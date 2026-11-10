# Maintenance

Maintenance = mise à jour des versions et du template.

## Versions

| Composant | Fichier |
|---|---|
| AGP | `template/build.gradle` |
| Gradle | `template/gradle/wrapper/gradle-wrapper.properties` |
| SDK / Build Tools | `template/app/build.gradle` |
| Défauts CLI | `new-project.sh` |
| Dépendances | `template/app/build.gradle` |

Matrice :

```text
JDK 17 ↔ Gradle 8.7 ↔ AGP 8.6.1 ↔ API 35
```

## Mettre à jour

1. Choisir une version compatible.
2. Modifier le template.
3. Modifier les défauts de `new-project.sh`.
4. Mettre à jour la documentation.
5. Regénérer un projet.
6. Compiler et linter.

## AGP

```groovy
// template/build.gradle
id 'com.android.application' version 'X.Y.Z' apply false
```

## Gradle

```properties
# template/gradle/wrapper/gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-X.Y-bin.zip
```

Installer la même version sur la machine.
Mettre à jour le wrapper si nécessaire.

## SDK

```groovy
// template/app/build.gradle
compileSdk 35
buildToolsVersion '35.0.0'

defaultConfig {
    targetSdk 35
}
```

Puis dans `new-project.sh` :

```bash
TARGET_SDK=35
COMPILE_SDK=35
BUILD_TOOLS="35.0.0"
```

## Dépendances

Modifier :

```groovy
// template/app/build.gradle
implementation 'androidx.appcompat:appcompat:...'
implementation 'com.google.android.material:material:...'
implementation 'androidx.constraintlayout:constraintlayout:...'
```

Tester après chaque changement.

## Vérifications

```bash
cd "$HOME/build_android_java"

bash -n new-project.sh
./new-project.sh --help

rm -rf /tmp/test
./new-project.sh Test com.example.test --output /tmp/test
cd /tmp/test/Test
gradle :app:assembleDebug
gradle :app:lintDebug
```

Avec tests :

```bash
./new-project.sh TestTests com.example.tests \
  --with-tests --output /tmp/tests
cd /tmp/tests/TestTests
gradle :app:assembleDebugAndroidTest
```

## Release

Voir [RELEASE.md](RELEASE.md).

## Règle d'or

Ne pas changer une version sans vérifier :

- JDK ;
- Gradle ;
- AGP ;
- SDK ;
- Build Tools.
