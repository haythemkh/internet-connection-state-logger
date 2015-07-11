#!/bin/bash

LOGFILE=$HOME'/internet-connection-state.log'

if ! which mplayer > /dev/null; then
  echo "Mplayer not found. Please install it by typing 'sudo apt-get install mplayer'"
  exit 1;
fi

function check {
  ping -w 1 -c 1 $1;
}

function play {
  $1 beep.wav 2>/dev/null 1>>$LOGFILE &
}

hosts=(`ip route | grep default | awk '{print $3}'` "google.com" "stackoverflow.com")

echo "> Daemon started at `date +%d/%m/%Y' '%T`" >> $LOGFILE

for (( ; ; )); do
  for item in "${hosts[@]}"; do

    echo " * Checking $item" >> $LOGFILE

    if check $item > /dev/null; then
      echo "`date +%d/%m/%Y' '%T`: Up" >> $LOGFILE
    else
      echo "`date +%d/%m/%Y' '%T`: DOWN - $item " >> $LOGFILE
      play mplayer
    fi
  done
  sleep 10
done
