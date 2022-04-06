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
ZIP_NOEXT=${ZIP%.zip}
DIR=$(basename $(dirname "$URL"))

mkdir "$DIR"
wget -q -P "$DIR" "$URL"
unzip -q -d "$DIR/$ZIP_NOEXT" "$DIR/$ZIP"
rm "$DIR/$ZIP"

rm -rf "$DIR/$ZIP_NOEXT/__MACOSX"

# Delete all PNG files
find "$DIR/$ZIP_NOEXT -name '*.png' -delete
