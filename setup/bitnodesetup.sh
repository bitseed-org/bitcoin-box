#finds external ip address, creates a wallet address, and posts to bitnodes.io
#before running this, the node needs to be activated via broswer by going to //getaddr.bitnodes.io/nodes/<ADDRESS>-<PORT>
#where <ADDRESS>-<PORT> is in the form xxx.xxx.xxx.xxx-8333
wget http://ipecho.net/plain &> /dev/null
ipadr=$(<plain)
echo "External IP address is:$ipadr"
echo -n "Enter port of web page showing BTC address (80 default):"
read prt
ipadrpt=$ipadr-$prt
echo "$ipadrpt"
ur="url=hppt://$ipadrpt"
echo "$ur"
echo "Enter bitcoin address to receive rewards:"
rm reward-addr
./bitcoin-cli getnewaddress > reward-addr
btcadr=$(<reward-addr)
echo "public IP:$ipadr"
echo "bitcoin address:$btcadr"
btcaddress="bitcoin_address=$btcadr"
echo "$btcaddress"
curl --ipv4 -H 'Accept: application/json; indent=4' -d '$btcaddress' -d '$ur' https://getaddr.bitnodes.io/api/v1/nodes/$ipadr-8333/
rm plain
