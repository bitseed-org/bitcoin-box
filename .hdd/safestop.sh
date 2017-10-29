#!/bin/bash
#stops bitcoind and shuts down device when /home/linaro/retartflag is set to 2
#intended to be run by sudo crontab -e  (root crontab) every minute
rsflag=$( < /home/linaro/restartflag)
#echo "Flag= $rsflag"
if (( rsflag == 2 )); then
 echo "stopiing bitcoind, please wait"
echo 0 > /home/linaro/restartflag
$HOME/bitcoin-cli stop
echo "Do not shut down the device until notified"
$x=$(pgrep -f bitcoind)
while [ "$x" !=  "" ]
do
  echo -n "."
  sleep 1s
  x=$(pgrep -f bitcoind)
done
echo "bitcoin has stopped. shutdown in 5 seconds"
sleep 10s
sudo shutdown -h now
fi
