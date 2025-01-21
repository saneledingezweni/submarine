#!/bin/bash
MIN=$1
while true; do
    python3 main.py $MIN --cache=".cache/*"
    sleep 10
done
