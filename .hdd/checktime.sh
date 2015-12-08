#check system date and reboot if way old
#must run as root or sudo
d=$(date +%s)
echo "$d"
if [ "$d" -lt "1422748800" ]; then
  echo "system date is incorrect, rebooting" >> /home/linaro/cron.log
  reboot
fi

