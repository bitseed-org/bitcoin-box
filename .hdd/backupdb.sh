#!/bin/bash
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then 
  echo "bitcoind not running"
  echo "bitcoind not running $(date)" >> bak.log
else
  echo "stopping bitcoind to run backup"
  sh /home/linaro/btcstop.sh
  sleep 5s 
  echo "backing up db"
  rsync --checksum --info=progress2 -r /home/linaro/.bitcoin /home/linaro/livebak
  echo $(date) >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/cron.log
  echo "db backup run $(date)" >> /home/linaro/bak.log
  echo "backup complete. restarting bitcoind"
  sh /home/linaro/btcstart.sh
fi
