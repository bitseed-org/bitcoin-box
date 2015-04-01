#re-enables suspended cron jobs for user linaro
#must be run as root or sudo
sudo mv /var/spool/cron/crontabs/linaro-suspend /var/spool/cron/crontabs/linaro
echo "cron jobs re-enabled.  Use cronstop.sh to disable cron jobs"
