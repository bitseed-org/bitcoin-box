#deletes the current bitcoind and bitcoin-cli binray files
#downloads XT 0.11b binaries and installs them
echo "removing bitcoin core and installing XT ... starts in 10 sec"
sleep 10s
#get XT binary files from bitseed.org
rm bitcoin-xt-0.11a.zip
rm -rf bitcoin-xt-0.11a
wget https://www.bitseed.org/device/bitcoin-xt-0.11b/XT11B-binaries.zip

#stop bitcoin
./btcstop.sh stop
sleep 10s

#remove old bitcoin binaries
rm /home/linaro/bitcoind
rm /home/linaro/bitcoin-cli

#install the XT binary files in /home/linaro
unzip XT11B-binaries.zip
cp XT11B-binaries/bitcoind  /home/linaro
cp XT11B-binaries/bitcoin-cli  /home/linaro

#restart bitcoind
echo "XT installed, bitcoin will now restart.  Allow about 10 minutes before it is active"
sleep 5s
./btcwatch.sh
