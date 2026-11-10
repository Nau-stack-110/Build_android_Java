#!/usr/bin/env bash
set -euo pipefail

# Resolve the real script directory even when invoked through a symlink.
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"
OPTIONAL_TESTS_DIR="$SCRIPT_DIR/optional-tests"

PROJECT_NAME=""
PACKAGE=""
APP_LABEL=""
MIN_SDK=24
TARGET_SDK=35
COMPILE_SDK=35
BUILD_TOOLS="35.0.0"
OUTPUT_DIR="$HOME/devko/mobile/android"
WITH_TESTS=0

usage() {
    cat <<'EOF'
Usage: android-new <nom-projet> <package> [options]

Options:
  --min-sdk N        minSdk (défaut : 24)
  --target-sdk N     targetSdk (défaut : 35)
  --compile-sdk N    compileSdk (défaut : 35)
  --build-tools V    version des Build Tools (défaut : 35.0.0)
  --output DIR       dossier parent (défaut : ~/devko/mobile/android)
  --app-label TEXTE  nom affiché (défaut : nom du projet)
  --with-tests       inclure ExampleUnitTest et ExampleInstrumentedTest
  -h, --help         afficher cette aide

Exemple :
  android-new MonApp com.naunau.monapp --min-sdk 24
EOF
}

die() {
    echo "Erreur : $*" >&2
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --min-sdk)
            [[ $# -ge 2 ]] || die "valeur manquante pour --min-sdk"
            MIN_SDK="$2"
            shift 2
            ;;
        --target-sdk)
            [[ $# -ge 2 ]] || die "valeur manquante pour --target-sdk"
            TARGET_SDK="$2"
            shift 2
            ;;
        --compile-sdk)
            [[ $# -ge 2 ]] || die "valeur manquante pour --compile-sdk"
            COMPILE_SDK="$2"
            shift 2
            ;;
        --build-tools)
            [[ $# -ge 2 ]] || die "valeur manquante pour --build-tools"
            BUILD_TOOLS="$2"
            shift 2
            ;;
        --output)
            [[ $# -ge 2 ]] || die "valeur manquante pour --output"
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --app-label)
            [[ $# -ge 2 ]] || die "valeur manquante pour --app-label"
            APP_LABEL="$2"
            shift 2
            ;;
        --with-tests)
            WITH_TESTS=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --*)
            die "option inconnue : $1"
            ;;
        *)
            if [[ -z "$PROJECT_NAME" ]]; then
                PROJECT_NAME="$1"
            elif [[ -z "$PACKAGE" ]]; then
                PACKAGE="$1"
            else
                die "trop d'arguments : $1"
            fi
            shift
            ;;
    esac
done

[[ -n "$PROJECT_NAME" ]] || { usage; exit 2; }
[[ -n "$PACKAGE" ]] || { usage; exit 2; }
[[ "$PROJECT_NAME" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || die "nom de projet invalide (lettres, chiffres, '.', '_', '-')"
[[ "$PACKAGE" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]] || die "package invalide (exemple : com.naunau.monapp)"
for v in "$MIN_SDK" "$TARGET_SDK" "$COMPILE_SDK"; do
    [[ "$v" =~ ^[0-9]+$ ]] || die "les versions SDK doivent être numériques"
done
[[ "$BUILD_TOOLS" =~ ^[0-9]+(\.[0-9]+)*$ ]] || die "version de Build Tools invalide"

APP_LABEL="${APP_LABEL:-$PROJECT_NAME}"
SDK_DIR="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
GRADLE_BIN="$(command -v gradle || true)"
[[ -n "$GRADLE_BIN" ]] || die "gradle introuvable dans le PATH"
GRADLE_HOME="$(cd -P "$(dirname "$GRADLE_BIN")/.." && pwd)"
ADB_BIN="$SDK_DIR/platform-tools/adb"
JAVA_HOME_DIR="${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")}"
PACKAGE_PATH="${PACKAGE//./\/}"
TARGET_DIR="$OUTPUT_DIR/$PROJECT_NAME"

[[ -d "$TEMPLATE_DIR" ]] || die "template introuvable : $TEMPLATE_DIR"
[[ -d "$SDK_DIR" ]] || die "SDK Android introuvable : $SDK_DIR"
[[ -n "$JAVA_HOME_DIR" && -d "$JAVA_HOME_DIR" ]] || die "JDK introuvable (JAVA_HOME)"
[[ ! -e "$TARGET_DIR" ]] || die "le dossier existe déjà : $TARGET_DIR"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$TARGET_DIR"
cp -R "$TEMPLATE_DIR/." "$TARGET_DIR/"

# Move MainActivity.java into the real package directory.
PLACEHOLDER_JAVA_DIR="$TARGET_DIR/app/src/main/java/__PACKAGE_PATH__"
DEST_JAVA_DIR="$TARGET_DIR/app/src/main/java/$PACKAGE_PATH"
mkdir -p "$DEST_JAVA_DIR"
mv "$PLACEHOLDER_JAVA_DIR/MainActivity.java" "$DEST_JAVA_DIR/MainActivity.java"
rmdir "$PLACEHOLDER_JAVA_DIR" 2>/dev/null || true

if [[ "$WITH_TESTS" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR/app/src/test/java/$PACKAGE_PATH"
    mkdir -p "$TARGET_DIR/app/src/androidTest/java/$PACKAGE_PATH"
    cp "$OPTIONAL_TESTS_DIR/app/src/test/java/__PACKAGE_PATH__/ExampleUnitTest.java" \
       "$TARGET_DIR/app/src/test/java/$PACKAGE_PATH/ExampleUnitTest.java"
    cp "$OPTIONAL_TESTS_DIR/app/src/androidTest/java/__PACKAGE_PATH__/ExampleInstrumentedTest.java" \
       "$TARGET_DIR/app/src/androidTest/java/$PACKAGE_PATH/ExampleInstrumentedTest.java"
fi

# Compute a resource-safe theme suffix from the project name.
THEME_SUFFIX="$(python3 - "$PROJECT_NAME" <<'PY'
import re
import sys

name = sys.argv[1]
safe = re.sub(r'[^A-Za-z0-9_]', '_', name)
safe = re.sub(r'_+', '_', safe).strip('_')
if not safe or safe[0].isdigit():
    safe = 'App_' + safe
print(safe)
PY
)"
THEME_NAME="Theme.$THEME_SUFFIX"
BASE_THEME_NAME="Base.Theme.$THEME_SUFFIX"

python3 - "$TARGET_DIR" "$PROJECT_NAME" "$APP_LABEL" "$PACKAGE" "$PACKAGE_PATH" \
    "$MIN_SDK" "$TARGET_SDK" "$COMPILE_SDK" "$BUILD_TOOLS" "$WITH_TESTS" \
    "$THEME_NAME" "$BASE_THEME_NAME" "$SDK_DIR" "$GRADLE_BIN" "$GRADLE_HOME" \
    "$ADB_BIN" "$JAVA_HOME_DIR" <<'PY'
import html
import os
import sys

(
    root,
    project_name,
    app_label,
    package,
    package_path,
    min_sdk,
    target_sdk,
    compile_sdk,
    build_tools,
    with_tests,
    theme_name,
    base_theme_name,
    sdk_dir,
    gradle_bin,
    gradle_home,
    adb_bin,
    java_home,
) = sys.argv[1:]

with_tests = with_tests == "1"
test_runner = (
    "testInstrumentationRunner 'androidx.test.runner.AndroidJUnitRunner'"
    if with_tests else ""
)
test_deps = (
    "    testImplementation 'junit:junit:4.13.2'\n"
    "    androidTestImplementation 'androidx.test.ext:junit:1.2.1'\n"
    "    androidTestImplementation 'androidx.test.espresso:espresso-core:3.6.1'"
    if with_tests else ""
)

replacements = {
    "__PROJECT_NAME__": project_name,
    "__APP_LABEL__": app_label,
    "__APP_LABEL_XML__": html.escape(app_label, quote=False),
    "__PACKAGE__": package,
    "__PACKAGE_PATH__": package_path,
    "__MIN_SDK__": min_sdk,
    "__TARGET_SDK__": target_sdk,
    "__COMPILE_SDK__": compile_sdk,
    "__BUILD_TOOLS__": build_tools,
    "__THEME_NAME__": theme_name,
    "__BASE_THEME_NAME__": base_theme_name,
    "__TEST_INSTRUMENTATION_RUNNER__": test_runner,
    "__TEST_DEPENDENCIES__": test_deps,
    "__SDK_DIR__": sdk_dir,
    "__GRADLE_BIN__": gradle_bin,
    "__GRADLE_HOME__": gradle_home,
    "__ADB_BIN__": adb_bin,
    "__JAVA_HOME__": java_home,
}

text_exts = (
    ".gradle", ".xml", ".java", ".json", ".md", ".properties",
    ".pro", ".txt", ".yml", ".yaml",
)
for dirpath, dirnames, filenames in os.walk(root):
    dirnames[:] = [d for d in dirnames if d not in (".git", "build", ".gradle")]
    for filename in filenames:
        if filename.endswith(text_exts):
            path = os.path.join(dirpath, filename)
            with open(path, "r", encoding="utf-8") as handle:
                content = handle.read()
            for old, new in replacements.items():
                content = content.replace(old, new)
            with open(path, "w", encoding="utf-8") as handle:
                handle.write(content)
PY

cat > "$TARGET_DIR/local.properties" <<EOF
sdk.dir=$SDK_DIR
EOF

chmod +x "$TARGET_DIR/gradlew" 2>/dev/null || true

cat <<EOF

Projet créé : $TARGET_DIR
Package     : $PACKAGE
minSdk      : $MIN_SDK
targetSdk   : $TARGET_SDK
compileSdk  : $COMPILE_SDK
Tests       : $([[ "$WITH_TESTS" -eq 1 ]] && echo "inclus" || echo "non inclus")

Prochaines étapes :
  cd "$TARGET_DIR"
  gradle :app:assembleDebug
  adb install -r app/build/outputs/apk/debug/app-debug.apk
  adb shell am start -n $PACKAGE/.MainActivity
EOF
