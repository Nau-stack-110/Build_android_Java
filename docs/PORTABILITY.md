# Portabilité

Portabilité = fonctionnement sur une autre machine.

## Support

| Système | Statut |
|---|---|
| Linux x86_64 | ✅ |
| Autres Linux | ⚠️ |
| macOS / Windows | ❌ |

Android Studio n'est pas requis.

## Outils requis

| Outil | Version |
|---|---|
| JDK | 17 |
| Gradle | 8.7 |
| Android SDK | API 35 |
| Build Tools | 35.0.0 |
| Python | 3 |
| Bash | 3.2+ |

## À copier

Copier tout le dossier :

```text
android-scaffold/
├── new-project.sh
├── template/
└── optional-tests/
```

Ne pas copier :

- un projet généré ;
- `build/` ou `.gradle/` ;
- le cache `~/.gradle`.

## Chemins

Le script cherche :

| Élément | Ordre |
|---|---|
| SDK | `ANDROID_HOME` → `ANDROID_SDK_ROOT` → `~/Android/Sdk` |
| JDK | `JAVA_HOME` → chemin de `java` |
| Gradle | `gradle` dans le `PATH` |
| adb | `$ANDROID_HOME/platform-tools/adb` |

Conseils :

- Définir `JAVA_HOME`.
- Utiliser un JDK complet, pas un JRE.
- Mettre le vrai dossier Gradle dans le `PATH`.
- Éviter les symlinks pour Gradle.

## Projet généré

Le projet contient des chemins absolus dans :

- `local.properties` ;
- `gradle.properties` ;
- `.vscode/settings.json` ;
- `.vscode/tasks.json`.

Sur une autre machine :

1. régénérer le projet ;
2. ou corriger ces fichiers.

`local.properties` est ignoré par Git.
`.vscode/` ne l'est pas.

## Réseau

Le générateur fonctionne hors ligne.

Le premier build télécharge AGP et les dépendances.
Prévoir un accès à Google Maven et Maven Central.

Proxy :

```properties
# ~/.gradle/gradle.properties
systemProp.http.proxyHost=proxy.example.com
systemProp.http.proxyPort=8080
systemProp.https.proxyHost=proxy.example.com
systemProp.https.proxyPort=8080
```

## Limites

- Linux uniquement.
- Gradle système obligatoire.
- Pas de bundle hors ligne.
- Pas d'émulateur.
- Pas de signature release.
- Chemins absolus dans `.vscode/`.

## Checklist

- [ ] JDK 17
- [ ] Gradle 8.7
- [ ] SDK API 35 + Build Tools 35.0.0
- [ ] dossier complet copié
- [ ] `android-new --help`
- [ ] premier build réussi
