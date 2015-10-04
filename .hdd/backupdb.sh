#!/bin/bash

#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"

x=$(pgrep -f $coind)
if [ "$x" == "" ]; then 
  echo "$coin not running"
  echo "$coin not running $(date)" >> bak.log 
else
  echo "stop $coind to run backup"  
  ./coinstop.sh
  sleep 5s 
  echo "backing up db"
  rsync --checksum --info=progress2 -r $HOME/$coindir $HOME/livebak
  echo $(date) >> $HOME/cron.log
  echo "db backup run $(date)" >> $HOME/cron.log
  echo "db backup run $(date)" >> $HOME/bak.log
  echo "backup complete. restart $coind"
  ./coinwatch.sh
fi
