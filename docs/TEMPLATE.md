# Template

## Structure

```text
android-scaffold/
├── new-project.sh
├── template/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── java/__PACKAGE_PATH__/MainActivity.java
│   │       └── res/
│   │           ├── drawable/
│   │           ├── layout/
│   │           ├── mipmap-*/
│   │           ├── values/
│   │           ├── values-night/
│   │           └── xml/
│   ├── build.gradle
│   ├── settings.gradle
│   ├── gradle.properties
│   ├── gradle/wrapper/
│   ├── gradlew
│   ├── .vscode/
│   └── README.md
└── optional-tests/
```

## Fichiers importants

| Fichier | Rôle |
|---|---|
| `new-project.sh` | Génère le projet |
| `template/` | Projet de base |
| `optional-tests/` | Tests avec `--with-tests` |
| `template/app/build.gradle` | SDK, Java, dépendances |
| `template/build.gradle` | Version AGP |
| `template/settings.gradle` | Dépôts et nom du projet |
| `template/gradle.properties` | JDK et options Gradle |
| `template/.vscode/` | Tâches VS Code |
| `template/app/src/main/` | Code et ressources |

## Génération

1. Lire les options.
2. Vérifier les outils.
3. Copier `template/`.
4. Déplacer `MainActivity.java`.
5. Remplacer les placeholders.
6. Écrire `local.properties`.
7. Afficher les commandes.

`local.properties` n'est pas dans le template.
Il est créé à la génération.

## Placeholders

Placeholder = texte remplacé à la génération.

| Placeholder | Valeur |
|---|---|
| `__PROJECT_NAME__` | Nom du projet |
| `__PACKAGE__` | Package |
| `__PACKAGE_PATH__` | Package avec `/` |
| `__APP_LABEL_XML__` | Nom affiché |
| `__MIN_SDK__` | minSdk |
| `__TARGET_SDK__` | targetSdk |
| `__COMPILE_SDK__` | compileSdk |
| `__BUILD_TOOLS__` | Build Tools |
| `__THEME_NAME__` | Thème |
| `__BASE_THEME_NAME__` | Thème de base |
| `__TEST_INSTRUMENTATION_RUNNER__` | Runner de tests |
| `__TEST_DEPENDENCIES__` | Dépendances de tests |
| `__SDK_DIR__` | Chemin SDK |
| `__JAVA_HOME__` | Chemin JDK |
| `__GRADLE_BIN__` | Chemin Gradle |
| `__GRADLE_HOME__` | Dossier Gradle |
| `__ADB_BIN__` | Chemin adb |

## Règles

- Ne pas renommer `template/`.
- Copier tout le dossier.
- Les fichiers texte sont modifiés.
- Les PNG et le JAR ne sont pas modifiés.
- `MainActivity.java` est le seul fichier Java déplacé.

## Modifier le template

1. Ajouter le fichier dans `template/`.
2. Utiliser un placeholder si besoin.
3. Regénérer un projet.
4. Compiler.

## Tests optionnels

`--with-tests` ajoute :

- `ExampleUnitTest.java`
- `ExampleInstrumentedTest.java`

Dépendances :

- JUnit 4.13.2
- AndroidX Test 1.2.1
- Espresso 3.6.1
