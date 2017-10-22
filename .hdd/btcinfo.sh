./bitcoin-cli -datadir=$HOME/.bitcoin getinfo
echo -n "device ip: "
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
date
