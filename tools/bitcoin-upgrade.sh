#downloads latest bitcoin arm binaries and installes on bitseed
echo "upgrading bitcoin core"
sh /home/linaro/btcstop.sh
wget -4 https://bitseed.org/device/latestversion/bitcoinarm.zip
rm bitcoind
rm bitcoin-cli
rm bitcoin-tx
rm bitcoin-qt
unzip bitcoinarm.zip
rm bitcoinarm.zip
chmod 755 bitcoind
chmod 755 bitcoin-cli
echo "bitcoin core upgraded"
echo "restarting bitcoind.  Allow 15 minutes for bitcoin to startup"
sh /home/linaro/btcstart.sh
