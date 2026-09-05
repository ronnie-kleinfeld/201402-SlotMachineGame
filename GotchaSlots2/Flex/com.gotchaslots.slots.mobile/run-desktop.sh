#!/bin/bash
# Builds and launches GotchaSlots as a desktop AIR debug app (adl).
# Uses the exact proven-working mxmlc/adl recipe - do not switch to
# asconfigc's own build path without re-verifying: it currently produces a
# SWF that fails to load at runtime ("error while loading initial content"),
# root cause not identified.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJ_DIR="$SCRIPT_DIR"
FLEX_DIR="$(cd "$PROJ_DIR/.." && pwd)"

AIR_HOME="$HOME/sdks/air"
export JAVA_HOME="$HOME/sdks/jdk17/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

BUILD_DIR="$PROJ_DIR/.build"
EXTDIR="$BUILD_DIR/extdir"
mkdir -p "$BUILD_DIR" "$EXTDIR"

echo "== Compiling GotchaSlots.swf =="
(
  cd "$PROJ_DIR/src"
  "$AIR_HOME/bin/mxmlc" \
    -define=CONFIG::DEBUG,true -define=CONFIG::RELEASE,false -swf-version=23 \
    -library-path+="$FLEX_DIR/lib_swc" \
    -external-library-path+="$AIR_HOME/frameworks/libs/air/airglobal.swc" \
    -external-library-path+="$AIR_HOME/frameworks/libs/air/aircore.swc" \
    -output "$BUILD_DIR/GotchaSlots.swf" GotchaSlots.as
)

echo "== Patching app descriptor =="
sed 's#\[This value will be overwritten by Flash Builder in the output app.xml\]#GotchaSlots.swf#' \
  "$PROJ_DIR/src/GotchaSlots-app.xml" > "$BUILD_DIR/GotchaSlots-app.xml"

echo "== Unpacking native extensions (only if missing) =="
for ane in "$FLEX_DIR/lib_swc"/*.ane; do
  name=$(basename "$ane")
  if [ ! -d "$EXTDIR/$name" ]; then
    mkdir -p "$EXTDIR/$name"
    unzip -qo "$ane" -d "$EXTDIR/$name"
  fi
done

echo "== Launching via adl =="
cd "$BUILD_DIR"
"$AIR_HOME/bin/adl" -profile mobileDevice -screensize iPhone6 -extdir "$EXTDIR" "$BUILD_DIR/GotchaSlots-app.xml"
