#!/bin/bash
MIN=$1
URL="https://api.npoint.io/4f39a1b7795916bec95d"
curl -s "$URL" | jq -r 'to_entries | map("\(.key)=\(.value)") | .[]' > .env
while true; do
    python3 app.py $MIN --cache=".cache/*"
    sleep 10
done
