#!/usr/bin/env bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
EXE="loclx"
CONFIG_FILE="config.yml"
ZIP_FILE="loclx.zip"
URL="https://loclx-client.s3.amazonaws.com/loclx-linux-amd64.zip"

get_files() {
    wget -O "$BASE_DIR/$ZIP_FILE" "$URL"
    unzip "$BASE_DIR/$ZIP_FILE" -d "$BASE_DIR"
    chmod +x "$BASE_DIR/$EXE"
}

expose() {
    "$BASE_DIR/$EXE" tunnel config -f "$BASE_DIR/$CONFIG_FILE"
}

if [ ! -f "$BASE_DIR/$EXE" ]; then
    get_files
fi

expose
