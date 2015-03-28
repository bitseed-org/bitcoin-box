#disable HDD disk write cache - reduce chance of corruption due to power loss
sudo chown linaro:linaro /etc/hdparm.conf
echo 'write_cache = off' >> write_cache = off
sudo chown root:root /etc/hdparm.conf
