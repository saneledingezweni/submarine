#!/bin/bash

SESSION_NAME="MyApp"

while true; do
  # Lấy PID của tiến trình đầu tiên trong phiên Screen
  PID=$(screen -ls | grep "\.${SESSION_NAME}" | awk -F. '{print $1}' | tr -d ' \t')

  if [ -z "$PID" ] || ! ps -p "$PID" > /dev/null 2>&1; then
    echo "🔄 Screen session '$SESSION_NAME' not running properly. Restarting..."
    screen -dmS "$SESSION_NAME" bash start.sh
  else
    echo "✅ Screen session '$SESSION_NAME' is active (PID: $PID)."
  fi

  sleep 5
done
