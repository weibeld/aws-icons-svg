#!/bin/bash
#
# Download an AWS architecture icons assets package and clean it to contain
# only the SVG versions of the icons in the 48x48 px size.
#
# This script makes the following hard assumptions on the structure of the
# AWS assets package:
#
#   - It is a zip file
#   - The zip file contains a top-level folder
#   - The top-level folder contains a number of other zip files
#   - The secondary zip files contain folders and subfolders
#   - The subfolders that contain the icon files include the size in their
#     name, e.g., "64", "Arch_64", "Res_48_Dark"
#   - The size 48 exists for all icon sets, that is, every folder must
#     eventually contain a subfolder containing "*48*" in its name
#
# The above assumption are valid for package version 20210131 [1]. If the
# format of the package changes in future version, this script must be adapted.
#
# The latest version of the AWS architecture icon assets package is published
# on (select "Asset Package"):
#
#    https://aws.amazon.com/architecture/icons/
#
# [1] https://d1.awsstatic.com/webteam/architecture-icons/q1-2021/AWS-Architecture_Asset-Package_20210131.a41ffeeec67743738315c2585f5fdb6f3c31238d.zip

set -e
shopt -u nullglob

usage() {
  cat <<EOF
USAGE
  $(basename $0) <url>

ARGS
  <url>  URL of the AWS assets package. The latest version of this package is
         published on https://aws.amazon.com/architecture/icons/.
EOF
}

[[ "$#" -eq 1 ]] || { usage; exit 1; }

URL=$1
ROOT=$(pwd)

# Check whether the supplied directory contains size-specific subdirectories
is_leaf() {
  ls -d "$1"/*48*/ &>/dev/null
}

# Process a subdirectory: if it's a leaf, copy out all the SVG files of the
# desired size; else, recursively iterate through all the subdirectories.
process() {
  if is_leaf "$1"; then
    echo "Writing $ROOT/$1..."
    mkdir -p "$ROOT/$1"
    if ls "$1"/*48*/*.svg &>/dev/null; then
      mv "$1"/*48*/*.svg "$ROOT/$1"
    fi
  else
    for d in "$1"/*; do
      process "$1/$(basename "$d")"
    done
  fi
}

# Change into a temporary directory (stay there for the rest of the script)
TMP=$(mktemp -d)
cd "$TMP"

# Download and unzip assets package
wget --quiet -O tmp.zip "$URL"
unzip -q tmp.zip && rm tmp.zip
rm -rf __MACOSX
DIR=$(ls -d */ | head -n 1 | sed 's#/$##')

# Unzip and process each contained zip file
for z in $DIR/*.zip; do
  SUBDIR=${z%.*}
  unzip -q -d "$SUBDIR" "$z" && rm "$z"
  rm -rf "$SUBDIR/__MACOSX"
  process "$SUBDIR"
done
