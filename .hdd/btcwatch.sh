#!/bin/bash
#A watchdog script that keeps bitcoind running
#for Linaro 14.04 4/7/2015

#check if rsync in pregress"
z=$(pgrep -f rsync)
if [ "$z" != "" ]; then 
echo "rsync running - dont start btc"
exit
else
echo "rync not running - ok"
fi

#check system date
d=$(date +%s)
echo "$d"
if [ "$d" -lt "1422748800" ]; then
  echo "system date is incorrect, aborted startup" >> /home/linaro/cron.log
  exit 0
fi
echo "system date is > 2015-02-01, script will continue"
date >> /home/linaro/cron.log

#check if bitcoind is already running
x=$(pgrep -f bitcoind)
if [ "$x" == "" ]; then
  #if bitcoind not running then start it
  echo "start btc"
  ./bitcoind -daemon
  echo "wait 15 min and check if running"
  sleep 15m
  x=$(pgrep -f bitcoind)
  echo "PID:"$x
  if [ "$x" == "" ]; then
    #if bitcoind did not start properly, restore .bitcoin directory from local backup
    echo "start failed, restoring from backup $(date)" >> /home/linaro/cron.log
    echo "start failed, * restoring from backup * will resatrt in about 1hr"
    rm -rf /home/linaro/.bitcoin
    mkdir /home/linaro/.bitcoin
    cp /home/linaro/livebak/.bitcoin/bitcoin.conf /home/linaro/.bitcoin/
    rsync --checksum -r --info=progress2 /home/linaro/livebak/ /home/linaro
    sleep 1m
    echo "start btc after restore due to fail to run"
    ./bitcoind -daemon
    exit
  else
    echo "restart success"
    echo "btc restarted $(date)" >> /home/linaro/cron.log
  fi
else
 echo "already running PID:"$x
 echo "wait 15 min then check block status"
 sleep 15m
 
 #get current block height from local bitcoin-cli and display current block
 #bash btcinfo.sh &> info
 ./bitcoin-cli getblockcount > locblock
 b=$(<locblock)
 echo" Local Block: $b"
 
 #check of local blockchain is way out of date, if so, restore from backup
 echo "at block:"$b
 if [ "$b" -lt "300000" ]; then
   echo "oops! blockheight less than 300K - restoring from backup"
   sh /home/linaro/btcstop.sh
   sleep 5s
   rm -rf /home/linaro/.bitcoin
   mkdir /home/linaro/.bitcoin
   cp /home/linaro/livebak/.bitcoin/bitcoin.conf /home/linaro/.bitcoin/
   rsync --checksum -r --info=progress2 /home/linaro/livebak/ /home/linaro
   sleep 5s
   echo "start btc after restore due to low block count"
   sh /home/linaro/btcstart.sh
 fi
fi
