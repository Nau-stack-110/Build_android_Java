# Release portable

Release = archive prête à copier sur une autre machine.

Créer une archive du générateur pour l'installer ailleurs.

Prérequis : [INSTALL.md](INSTALL.md).

## 1. Créer l'archive

```bash
cd "$HOME/devko/tools"

VERSION=1.0.0
STAGE="/tmp/android-scaffold-$VERSION"

rm -rf "$STAGE"
cp -a android-scaffold "$STAGE"
rm -rf "$STAGE/.git" "$STAGE/.gradle" "$STAGE/build"

chmod +x "$STAGE/new-project.sh"
chmod +x "$STAGE/template/gradlew"

mkdir -p releases
tar -czf "releases/android-scaffold-$VERSION.tar.gz" \
  -C /tmp "android-scaffold-$VERSION"
```

## 2. Checksum

```bash
cd "$HOME/devko/tools/releases"

sha256sum "android-scaffold-$VERSION.tar.gz" \
  > "android-scaffold-$VERSION.tar.gz.sha256"

sha256sum -c "android-scaffold-$VERSION.tar.gz.sha256"
```

## 3. Vérifier

```bash
cd "$HOME/devko/tools/releases"

tar -tzf "android-scaffold-$VERSION.tar.gz" | head

rm -rf "/tmp/android-scaffold-$VERSION"
tar -xzf "android-scaffold-$VERSION.tar.gz" -C /tmp

"/tmp/android-scaffold-$VERSION/new-project.sh" --help
```

## 4. Installer

```bash
cd "$HOME/devko/tools/releases"

# Vérifier le fichier téléchargé
sha256sum -c android-scaffold-1.0.0.tar.gz.sha256

mkdir -p "$HOME/devko/tools"
tar -xzf android-scaffold-1.0.0.tar.gz -C "$HOME/devko/tools"

mkdir -p "$HOME/.local/bin"
ln -sfn "$HOME/devko/tools/android-scaffold-1.0.0/new-project.sh" \
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
ln -sfn "$HOME/devko/tools/android-scaffold-1.1.0/new-project.sh" \
        "$HOME/.local/bin/android-new"
```

## 6. Revenir en arrière

```bash
ln -sfn "$HOME/devko/tools/android-scaffold-1.0.0/new-project.sh" \
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
