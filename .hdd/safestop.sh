#!/bin/bash
#stops bitcoind and shuts down device when /home/linaro/retartflag is set to 2
#intended to be run by sudo crontab -e  (root crontab) every minute

#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"

rsflag=$( < $HOME/restartflag)
#echo "Flag= $rsflag"
if (( rsflag == 2 )); then
 echo "stopiing $coind, please wait"
echo 0 > $HOME/restartflag
$coincli stop
echo "Do not shut down the device until notified"
$x=$(pgrep -f $coind)
while [ "$x" !=  "" ]
do
  echo -n "."
  sleep 1s
  x=$(pgrep -f $coind)
done
echo "$coin has stopped. shutdown in 5 seconds"
sleep 10s
sudo shutdown -h now
fi
