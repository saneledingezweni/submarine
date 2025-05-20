#!/bin/bash

SESSION_NAME="AppCuaToi"

while true; do
  # Lấy PID của tiến trình đầu tiên trong phiên Screen
  PID=$(screen -ls | grep "\.${SESSION_NAME}" | awk -F. '{print $1}' | tr -d ' \t')

  if [ -z "$PID" ] || ! ps -p "$PID" > /dev/null 2>&1; then
    echo "🔄 Screen session '$SESSION_NAME' not running properly. Restarting..."

    # Nếu screen session cũ còn tồn tại, kill nó
    if screen -list | grep -q "\.${SESSION_NAME}"; then
      echo "🛑 Killing existing screen session '$SESSION_NAME'..."
      screen -S "$SESSION_NAME" -X quit
      sleep 1
    fi

    # Khởi động lại screen session
    screen -dmS "$SESSION_NAME" bash batdau.sh
  else
    echo "✅ Screen session '$SESSION_NAME' is active (PID: $PID)."
  fi

  sleep 60
done
