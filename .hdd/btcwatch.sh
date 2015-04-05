
#!/bin/bash
#A watchdog script that keeps bitcoind running
#for Linaro 14.04 3/31/2015
#check if backup is in progress"
z=$(pgrep -f backupdb)
if [ "$z" != "" ]; then 
  echo "backupdb.sh is running - not starting bitcoind"
  exit
else
  echo "backupdb.sh is not running - continuing"
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
  echo "starting bitcoind"
  ./bitcoind -daemon
  echo "waiting 15 min to check if bitcoind is running"
  sleep 15m
  x=$(pgrep -f bitcoind)
  echo "PID:"$x
  if [ "$x" == "" ]; then
    #if bitcoind did not start properly, restore .bitcoin directory from local backup
    echo "start failed, restoring from backup $(date)" >> /home/linaro/cron.log
    echo "start failed, * restoring from backup * will restart in about 1hr"
    rm -rf /home/linaro/.bitcoin
    mkdir /home/linaro/.bitcoin
    cp /home/linaro/livebak/.bitcoin/bitcoin.conf /home/linaro/.bitcoin/
    rsync --checksum -r --info=progress2 /home/linaro/livebak/ /home/linaro
    sleep 1m
    echo "start bitcoind after restore due to run failure"
    ./bitcoind -daemon
    exit
  else
    echo "restart success"
    echo "btc restarted $(date)" >> /home/linaro/cron.log
  fi
else
 echo "already running PID:"$x
 echo "wait 15 min to check block height"
 sleep 15m
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
 echo "at block:"$b
 if [ "$b" -lt "300000" ]; then
   echo "oops! block height less than 300K - restoring from backup"
   sh /home/linaro/btcstop.sh
   sleep 5s
   rm -rf /home/linaro/.bitcoin
   mkdir /home/linaro/.bitcoin
   cp /home/linaro/livebak/.bitcoin/bitcoin.conf /home/linaro/.bitcoin/
   rsync --checksum -r --info=progress2 /home/linaro/livebak/ /home/linaro
   sleep 5s
   echo "starting bitcoind after restore due to low block height"
   sh /home/linaro/btcstart.sh
 fi
fi
