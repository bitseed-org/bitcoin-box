#!/bin/bash
#A watchdog script that keeps bitcoind running
#for Linaro 14.04 4/7/2015

#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"


#get public IP and write to disk
dig +short myip.opendns.com @resolver1.opendns.com > extip

#check if rsync in progress"
z=$(pgrep -f rsync)
if [ "$z" != "" ]; then 
echo "rsync running - dont start $coin"
exit
else
echo "rync not running - ok"
fi

#check system date
d=$(date +%s)
echo "$d"
if [ "$d" -lt "1422748800" ]; then
  echo "system date is incorrect, aborted startup" >> $HOME/cron.log
  exit 0
fi
echo "system date is > 2015-02-01, script will continue"

#check if $coind is already running
x=$(pgrep -f $coind)
echo "x:$x"
if [ "$x" == "" ]; then
  #if bitcoind not running then start it
  echo "start $coin"
  ./$coind -daemon
  echo "wait 10 min and check if running"
  sleep 10m
  x=$(pgrep -f $coind)
  echo "PID:"$x
  if [ "$x" == "" ]; then
    #if $coind did not start properly, restore .bitcoin directory from local backup
    echo "start failed, restoring from backup $(date)" >> /home/linaro/cron.log
    echo "start failed, * restoring from backup * will resatrt in about 1hr"
    rm -rf $HOME/$coindir
    mkdir $HOME/$coindir
    cp $HOME/livebak/$coindir/$coinconf $HOME/$coindir/
    rsync --checksum -r --info=progress2 $HOME/livebak/ $HOME
    sleep 1m
    echo "start $coin after restore due to fail to run"
    ./$coind -daemon
    exit
  else
    echo "restart success"
    echo "$coin restarted $(date)" >> $HOME/cron.log
  fi
else
 echo "already running PID:"$x
 echo "wait 15 min then check block status"
 sleep 15m
 
 #get current block height from local bitcoin-cli and display current block
 #bash btcinfo.sh &> info
 $coincli getblockcount > locblock
 b=$(<locblock)
 echo " Local Block: $b"
 rm locblock
 #check of local blockchain is way out of date, if so, restore from backup
 echo "at block:"$b
 if [ "$b" -lt "300000" ]; then
   echo "oops! blockheight less than 300K - restoring from backup"
   sh $HOME/coinstop.sh
   sleep 5s
   rm -rf $HOME/$coindir
   mkdir $HOME/$coindir
   cp $HOME/livebak/$coindir/$coinconf $HOME/$coindir/
   rsync --checksum -r --info=progress2 $HOME/livebak/ $HOME
   sleep 5s
   echo "start $coin after restore due to low block count"
   ./$coind -daemon
 fi
fi
