#check system date
d=$(date +%s)
echo "$d"
if [ "$d" -lt "1422748800" ]; then 
  echo "system date is incorrect, aborted startup" >> /home/linaro/cron.log
  exit 0  
fi
/home/linaro/bitcoind -datadir=/home/linaro/.bitcoin -daemon
