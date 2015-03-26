sudo rm /etc/mac
cp /home/linaro/bitcoin-box/.hdd/*.sh /home/linaro
sudo chown -R linaro:linaro /home/linaro
chmod 755 /home/linaro/*.sh

#disable screensaver becuase it uses too much CPU
rm /home/linaro/.config/lxsession/LXDE/autostart
echo "@lxpanel --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@pcmanfm --desktop --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1" >> /home/linaro/.config/lxsession/LXDE/autostart
