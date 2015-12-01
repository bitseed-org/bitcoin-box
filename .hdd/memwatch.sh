#!/bin/bash

#watch device free memory.  
#restart bitcoind if less than 50MB free
#fm=$(free | grep Mem | awk '{print $4/$2 * 1000.0}' | bc)
fm=$(awk '/^-/ {print $4}' <(free -m))
a=$(echo "$fm < 100" | bc)
#fm=$(cat freemem)
echo "$fm" >> cron.log
if [ "$a" -eq "1" ]; then
 echo "$(date) free mem + buffers is $fm, restarting" >> cron.log
 echo 1 > $HOME/restartflag
fi

