#!/bin/bash
#A watchdog script that keeps bitcoind running
#for Linaro 14.04 12/31/2014
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
  sh /home/linaro/btcstart.sh
  sleep 20s
  x=$(pgrep -f bitcoind)
  if [ "$x" == "" ]; then
    #if bitcoind did not start properly, restore .bitcoin directory from local backup
    echo "start failed, restoring from backup $(date)" >> /home/linaro/cron.log
    echo "start failed, * restoring from backup * will resatrt in about 1hr"
    rsync --checksum -r /home/linaro/livebak/ /home/linaro
    sleep 1m
    echo "start btc after restore"
    sh /home/linaro/btcstart.sh
  else 
    echo "restart success"
    echo "btc restarted $(date)" >> /home/linaro/cron.log
  fi
else 
echo "running PID:"$x
fi
sleep 5s
#get current block height from local bitcoin-cli and display current block
#bash btcinfo.sh &> info
./bitcoin-cli -datadir=/home/linaro/.bitcoin getinfo &> info
sed -n 6p info > line1
awk -F':' '{print $2}' line1 > tmp1
awk -F',' '{print $1}' tmp1 > locblock
echo -n "Local Block: "
#cat locblock
b=$(<locblock)
echo $b
rm tmp1
rm info
rm line1
#check of local blockchain is way out of date, if so, restore from backup
#echo "at block:"$b
if [ "$b" -lt "300000" ]; then
   sh /home/linaro/btcstop.sh
   sleep 10s
   rsync --checksum -r /home/linaro/livebak/ /home/linaro
   sleep 5s
   echo "start btc after restore"
   sh /home/linaro/btcstart.sh
fi
