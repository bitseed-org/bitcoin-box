#downloads latest bitcoin arm binaries and installes on bitseed
echo "upgrading bitcoin core"
wget -4 https://bitseed.org/device/latestversion/bitcoinarm.zip
rm bitcoind
rm bitcoin-cli
rm bitcoin-tx
rm bitcoin-qt
unzip bitcoinarm.zip
rm bitcoinarm.zip
echo "bitcoin core upgraded"
