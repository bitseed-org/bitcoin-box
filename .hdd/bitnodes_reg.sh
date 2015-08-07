#this script automates bitnodes registration
echo "Bitnodes requires that you publish a web page at the same public IP address as your node."
echo " A page will be served fron the bitseed device on port 80, but usually your router must be set to open or map the bitseed port 80 to an external port"
wget http://ipecho.net/plain &> /dev/null
ipadr=$(<plain)
echo "External IP address is:$ipadr"
echo -n "Enter the external port of web page showing BTC address (80 default):"
read prt
ipadrpt=$ipadr-$prt
echo "$ipadrpt"
ur="url=hppt://$ipadrpt"
echo "$ur"
urlnodes="$ipadr-8333"
echo "urlnodes: $urlnodes"
echo "Enter bitcoin address to receive rewards:"
read btcadr
echo "public IP:$ipadr"
echo "bitcoin address:$btcadr"
intip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo "$intip"
echo ""
#curl -H 'Accept: application/json; indent=4' -d 'bitcoin_address=14A7JMpQMKPUD3zvefovijodfivuSeW6' -d 'url=http://23.456.78.9' https://getaddr.bitnodes.io/api/v1/nodes/23.456.78.9-8333/
curl -H "Accept: application/json; indent=4" -d "bitcoin_address=$btcadr" -d "url=http://$ipadr:$prt" https://getaddr.bitnodes.io/api/v1/nodes/$urlnodes/
#echo ""
rm plain
#bitnodes requires use of a restricted port <1024.  upnp will not work on ports <1024 for most routers
#intip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
#echo "$intip"
#upnpc -a $intip 80 $prt TCP
echo "bitnodes registration sent.  If successful, the bitnodes status in the GUI will show as "verified" within about 5-10 minutyes"
