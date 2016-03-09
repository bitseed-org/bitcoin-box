
#!/bin/bash
#stops and starts bitcoind when restartflag file is set to 1
#does nothing in all other cases
#intended to be run every minute by cronttab:
#* * * * * bash /home/linaro/restartbtc.sh

#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"

rsflag=$( < /home/linaro/restartflag)
#echo "Flag= $rsflag"
if (( rsflag == 1 )); then
 echo "restarting $coind, please wait"
echo 0 > /home/linaro/restartflag
./$coincli stop
echo "Do not shut down the device until notified"
$x=$(pgrep -f $coind)
while [ "$x" !=  "" ]
do
  echo -n "."
  sleep 1s
  x=$(pgrep -f $coind)
done
echo "$coin has stopped. restart in 5 seconds"
sleep 10s
echo "starting $coind, pleese wait 15 min"
./$coind -daemon
fi
