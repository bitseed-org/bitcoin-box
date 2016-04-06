#!/bin/bash
#Name:myscript.sh
#Desc:Run script in every 20 seconds
while (sleep 5 && ./lin_wr_launch.py) &
do
 wait $!
done
