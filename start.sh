#!/bin/bash
MIN=$1
URL="https://api.npoint.io/4f39a1b7795916bec95d"
# Check for curl or wget
if command -v curl >/dev/null 2>&1; then
    FETCH_CMD="curl -s"
elif command -v wget >/dev/null 2>&1; then
    FETCH_CMD="wget -qO-"
else
    echo "Error: Neither curl nor wget is installed. Please install one of them." >&2
    exit 1
fi
# Fetch and process JSON into .env format
$FETCH_CMD "$URL" | sed -E 's/[{}"]//g' | tr ',' '\n' | awk -F':' '
{
    key=$1; value=$2;
    gsub(/^ /, "", key);
    gsub(/^ /, "", value);
    if (length(value) > 0) print key "=" substr($0, index($0, ":") + 1);
}' > .env
while true; do
    python3 app.py $MIN --cache=".cache/*"
    sleep 10
done
