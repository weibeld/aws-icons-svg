#!/bin/bash

set -e

usage() {
  cat <<EOF
USAGE
  $(basename $0) <url>

ARGS
  <url>  AWS asset package (see https://aws.amazon.com/architecture/icons/)
EOF
}

[[ "$#" -eq 1 ]] || { usage; exit 1; }

URL=$1
ZIP=$(basename "$URL")
DIR=$(basename $(dirname "$URL"))

# Download and unzip asset package
mkdir "$DIR"
wget -q -P "$DIR" "$URL"
unzip -q -d "$DIR" "$DIR/$ZIP"
rm "$DIR/$ZIP"
rm -rf "$DIR/__MACOSX"

# Store base name of ZIP file (containing the exact version) in version file
echo "${ZIP%.zip}" >>"$DIR/version"

# Delete all PNG files
find "$DIR" -name '*.png' -delete
