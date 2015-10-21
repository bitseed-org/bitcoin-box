
#!/bin/bash
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then
  echo "btc not running"
  echo "btc not running $(date)" >> bak.log
else
  echo "stop bitcoind to run backup"
  sh /home/linaro/btcstop.sh
  sleep 5s
  echo "backing up db"
 rsync --checksum --info=progress2 -r /home/linaro/.bitcoin bitseed@192.168.1.4:/home/bit$
# rsync --checksum --info=progress2 -r /home/linaro/.bitcoin bitseed@192.168.1.4:/home/bi$
  echo $(date) >> /home/linaro/cron.log
  echo "remote db backup run $(date)" >> /home/linaro/cron.log
  echo "remote db backup run $(date)" >> /home/linaro/bak.log
  echo "backup complete. restart bitcoind"
  sh /home/linaro/btcstart.sh
fi
