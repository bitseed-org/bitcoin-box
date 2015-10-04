#!/bin/bash

#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"

$coincli stop

echo "Do not shut down the device until notified"
x=$(pgrep -f $coind)
while [ "$x" !=  "" ]
do
  echo -n "."
  sleep 1s
  x=$(pgrep -f $coind)
done
echo "$coin has stopped.  OK to shutdown"
