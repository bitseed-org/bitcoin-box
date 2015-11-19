
#removes Tor onion settings from bitcoin.conf
#restores bitcoin.conf to standard config
$HOME/btcstop.sh
echo "remove Tor settings from bitcoin.conf"

sed -i '/onlynet=Tor/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/onion=127.0.0.1:9050/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/listen=1/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/bind=127.0.0.1:8333/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/externalip=$onion/d' $HOME/.bitcoin/bitcoin.conf

#these are other Tor nodes that will help your node find peers
sed -i '/seednode=.*/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/seednode=xqzfakpeuvrobvpj.onion/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/seednode=tsyvzsqwa2kkf6b2.onion/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/banscore=10000/d' $HOME/.bitcoin/bitcoin.conf
sed -i '/bantime=11/d' $HOME/.bitcoin/bitcoin.conf

echo "1" > restartflag
