# build_android_java

Générateur de projets Android Java pour Linux.
Fonctionne sans Android Studio.

`android-new` crée un projet Gradle prêt à compiler.

## Démarrage rapide

```bash
source ~/.zshrc
android-new MonApp com.naunau.monapp --output "$HOME/AndroidProjects"
cd "$HOME/AndroidProjects/MonApp"
gradle :app:assembleDebug
```

APK :

```text
app/build/outputs/apk/debug/app-debug.apk
```

Installer sur un téléphone :

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.naunau.monapp/.MainActivity
```

`adb` installe l'application sur le téléphone.

## Prérequis

| Outil | Version |
|---|---|
| Linux | x86_64 |
| JDK | 17 |
| Gradle | 8.7 |
| Android SDK | API 35 |
| Build Tools | 35.0.0 |
| Python | 3 |
| Git | récent |
| Bash | 3.2+ |

Android Studio n'est pas nécessaire.

JDK = Java. SDK = outils Android. Gradle = compilation.

Installation complète : [docs/INSTALL.md](docs/INSTALL.md).

## Installation

Cloner tout le dépôt `build_android_java`.
Le script seul ne suffit pas.

```bash
git clone https://github.com/Nau-stack-110/Build_android_Java.git \
  "$HOME/build_android_java"

mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/build_android_java/new-project.sh" \
        "$HOME/.local/bin/android-new"

export PATH="$HOME/.local/bin:$PATH"
```

Recharger le shell :

```bash
source ~/.zshrc
```

Vérifier :

```bash
android-new --help
```

## Utilisation

```bash
android-new <projet> <package> [options]
```

Exemple :

```bash
android-new MonApp com.naunau.monapp --output "$HOME/AndroidProjects"
```

Création :

```text
~/AndroidProjects/MonApp
```

### Options

| Option | Valeur | Rôle |
|---|---|---|
| `--min-sdk N` | `24` | SDK minimum |
| `--target-sdk N` | `35` | SDK cible |
| `--compile-sdk N` | `35` | SDK de compilation |
| `--build-tools V` | `35.0.0` | Build Tools |
| `--output DIR` | `~/AndroidProjects` | Dossier parent |
| `--app-label TEXTE` | nom du projet | Nom affiché |
| `--with-tests` | non | Ajoute deux tests |
| `--help` | — | Affiche l'aide |

### Règles

- Nom : lettres, chiffres, `.`, `_`, `-`.
- Package : identifiant de l'application.
  Minuscules, au moins deux parties.
  Exemple : `com.naunau.monapp`.
- Le dossier de destination doit être absent.

## Commandes utiles

```bash
cd ~/AndroidProjects/MonApp

gradle :app:assembleDebug   # compiler
gradle :app:lintDebug       # vérifier
gradle clean                # nettoyer
```

VS Code est optionnel.
Les tâches sont dans `.vscode/`.

## Documentation

| Fichier | Contenu |
|---|---|
| [INSTALL](docs/INSTALL.md) | Installer sur Linux |
| [PORTABILITY](docs/PORTABILITY.md) | Copier sur une autre machine |
| [RELEASE](docs/RELEASE.md) | Créer une archive portable |
| [TEMPLATE](docs/TEMPLATE.md) | Structure du template |
| [TROUBLESHOOTING](docs/TROUBLESHOOTING.md) | Erreurs courantes |
| [MAINTENANCE](docs/MAINTENANCE.md) | Mettre à jour les versions |

## Limites

- Linux uniquement.
- Gradle système obligatoire.
- Réseau nécessaire au premier build.
- Chemins absolus dans le projet généré.
- Pas d'émulateur ni de signature release.

## Testé avec

Parrot OS 6.3, JDK 17.0.13, Gradle 8.7,
AGP 8.6.1, API 35, Build Tools 35.0.0.
