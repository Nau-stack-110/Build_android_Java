# Release portable

Release = archive prête à copier sur une autre machine.

Créer une archive du générateur pour l'installer ailleurs.

Prérequis : [INSTALL.md](INSTALL.md).

## 1. Créer l'archive

Le dépôt est dans `~/build_android_java`.

```bash
cd "$HOME"

VERSION=1.0.0
STAGE="/tmp/build_android_java-$VERSION"

rm -rf "$STAGE"
cp -a build_android_java "$STAGE"
rm -rf "$STAGE/.git" "$STAGE/.gradle" "$STAGE/build"

chmod +x "$STAGE/new-project.sh"
chmod +x "$STAGE/template/gradlew"

mkdir -p releases
tar -czf "releases/build_android_java-$VERSION.tar.gz" \
  -C /tmp "build_android_java-$VERSION"
```

## 2. Checksum

```bash
cd "$HOME/releases"

sha256sum "build_android_java-$VERSION.tar.gz" \
  > "build_android_java-$VERSION.tar.gz.sha256"

sha256sum -c "build_android_java-$VERSION.tar.gz.sha256"
```

## 3. Vérifier

```bash
cd "$HOME/releases"

tar -tzf "build_android_java-$VERSION.tar.gz" | head

rm -rf "/tmp/build_android_java-$VERSION"
tar -xzf "build_android_java-$VERSION.tar.gz" -C /tmp

"/tmp/build_android_java-$VERSION/new-project.sh" --help
```

## 4. Installer

```bash
cd "$HOME/releases"

# Vérifier le fichier téléchargé
sha256sum -c build_android_java-1.0.0.tar.gz.sha256

tar -xzf build_android_java-1.0.0.tar.gz -C "$HOME"

mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/build_android_java-1.0.0/new-project.sh" \
        "$HOME/.local/bin/android-new"
```

Vérifier :

```bash
android-new --help
```

## 5. Mettre à jour

Installer la nouvelle version dans un nouveau dossier.
Changer le symlink :

```bash
ln -sfn "$HOME/build_android_java-1.1.0/new-project.sh" \
        "$HOME/.local/bin/android-new"
```

## 6. Revenir en arrière

```bash
ln -sfn "$HOME/build_android_java-1.0.0/new-project.sh" \
        "$HOME/.local/bin/android-new"
```

Les projets déjà générés ne changent pas.

## Checklist

- [ ] archive versionnée
- [ ] checksum OK
- [ ] `new-project.sh` exécutable
- [ ] `template/` et `optional-tests/` présents
- [ ] `android-new --help` OK
- [ ] un projet test compile
