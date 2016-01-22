#check system date and reboot if it is way old
#if device fail to get internet time at boot, date wull be Jan 1, 2010, which would corrup$
d=$(date +%s)
echo "$d"
if [ "$d" -lt "1422748800" ]; then
  echo "system date is incorrect, stop bitcoin and reboot" >> /home/linaro/cron.log

/home/linaro/bitcoin-cli stop
echo "Do not shut down the device until notified"
$x=$(pgrep -f bitcoind)
while [ "$x" !=  "" ]
do
  echo -n "."
  sleep 1s
  x=$(pgrep -f bitcoind)
done
echo "bitcoin has stopped. reboot in 5 seconds"
sleep 10s
sudo reboot

