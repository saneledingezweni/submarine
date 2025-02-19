#!/bin/bash
MIN=$1
URL="https://api.npoint.io/4f39a1b7795916bec95d"
curl -s "$URL" | sed -E 's/[{}"]//g' | tr ',' '\n' | awk -F':' '
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
