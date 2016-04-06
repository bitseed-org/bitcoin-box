#!/bin/bash
#Name:myscript.sh
#Desc:Run script in every 20 seconds
#while (sleep 5 && ./test_cron.py) &

# Check the mailbox.  If there is an action value,
# execute the action, otherwise, sleep N more seconds
while (sleep 5 && ./lin_rd_launch.py) &
do
 wait $!
done
