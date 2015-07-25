#this script automates bitnodes registration
echo "Bitnodes requires that you publish a web page at the same public IP address as your node. A page will be served fron the bitseed device on port 80, but you may need to manually set you router to map the bitseed page to an external port"
wget http://ipecho.net/plain &> /dev/null
ipadr=$(<plain)
echo "External IP address is:$ipadr"
echo -n "Enter the external port of web page showing BTC address (80 default):"
read prt
ipadrpt=$ipadr-$prt
echo "$ipadrpt"
ur="url=hppt://$ipadrpt"
echo "$ur"
echo "Enter bitcoin address to receive rewards:"
rm reward-addr
read reward-addr
btcadr=$(<reward-addr)
echo "public IP:$ipadr"
echo "bitcoin address:$btcadr"
btcaddress="bitcoin_address=$btcadr"
echo "$btcaddress"
curl --ipv4 -H 'Accept: application/json; indent=4' -d '$btcaddress' -d '$ur' https://getaddr.bitnodes.io/$
rm plain
#curl --ipv4 -H 'Accept: application/json; indent=4' -d 'bitcoin_address=1DXam6ZsoajEihNuVqdGUWQLUDC1Yph4f$
echo "bitnodes registration sent.  If successful, the bitnodes status in the GUI will show as "verified" within about 5-10 minutyes"


