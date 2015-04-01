#disables cron jobs for user linaro
#must be run as root or sudo
sudo mv /var/spool/cron/crontabs/linaro /var/spool/cron/crontabs/linaro-suspend
echo "cron jobs disabled.  Use cronenable.sh to re-enable cron jobs"
