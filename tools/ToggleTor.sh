#switch bitcoind between Tor and default ip4
status=$(sed -n '/onlynet=Tor/p' $HOME/.bitcoin/bitcoin.conf)
if [ "$status"=="onlynet=Tor" ]; then 
  echo "tor enabled"
  echo "bitcoin is set to use Tor"
  echo "stop using Tor? y/n"
  read a
  if [ "$a"=="y" ]; then
    echo "dsiable script will run"

    #removes Tor onion settings from bitcoin.conf
    #restores bitcoin.conf to standard config
    $HOME/btcstop.sh
    echo "removing Tor settings from bitcoin.conf"

    sed -i '/onlynet=Tor/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/onion=127.0.0.1:9050/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/listen=1/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/bind=127.0.0.1:8333/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/externalip*/d' $HOME/.bitcoin/bitcoin.conf

    #these are other Tor nodes that will help your node find peers
    sed -i '/seednode=.*/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/seednode=xqzfakpeuvrobvpj.onion/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/seednode=tsyvzsqwa2kkf6b2.onion/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/banscore=10000/d' $HOME/.bitcoin/bitcoin.conf
    sed -i '/bantime=11/d' $HOME/.bitcoin/bitcoin.conf

    echo "1" > $HOME/restartflag

    else
    exit 
  fi
  else
  if [ "$status"!="onlynet=Tor" ]; then 
    echo "Bitcoin not using Tor"
    echo "Switch to Tor? y/n"
    read a
    if [ "$a"=="y" ]; then
      echo "enable script will run"

      # configure bitcoin.conf
      sh /home/linaro/btcstop.sh
      echo #Tor Settings
      echo "onlynet=Tor" >> $HOME/.bitcoin/bitcoin.conf
      echo "onion=127.0.0.1:9050" >> $HOME/.bitcoin/bitcoin.conf
      echo "listen=1" >> $HOME/.bitcoin/bitcoin.conf
      echo "bind=127.0.0.1:8333" >> $HOME/.bitcoin/bitcoin.conf
      echo "externalip=$onion"  >> $HOME/.bitcoin/bitcoin.conf
      #these are other Tor nodes that will help your node find peers
      echo "seednode=nkf5e6b7pl4jfd4a.onion" >> $HOME/.bitcoin/bitcoin.conf
      echo "seednode=xqzfakpeuvrobvpj.onion" >> $HOME/.bitcoin/bitcoin.conf
      echo "seednode=tsyvzsqwa2kkf6b2.onion" >> $HOME/.bitcoin/bitcoin.conf
      #these lines help limit potential DOS attacks over Tor
      echo "banscore=10000" >> $HOME/.bitcoin/bitcoin.conf
      echo "bantime=11" >> $HOME/.bitcoin/bitcoin.conf
      #sh /home/linaro/btcstart.sh
      echo "1" > $HOME/restartflag
      echo "Tor will now run automatically and publish the bitcoin node as a hidden service"
      echo "Bitcoin will only connect to peers over the Tor Onion network."
      fi
    fi 
  fi
