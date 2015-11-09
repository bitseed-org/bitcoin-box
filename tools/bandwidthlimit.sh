#Script to set up iptables to limit peak bandwidth to bitcoind
#from romanz/fullnode.md
#if too low, bandwidth limit will cause the node to lag the network

#network interface on which to limit traffic
IF="eth0"
#limit of the network interface in question
LINKCEIL="1gbit"
#limit outbound Bitcoin protocol traffic to this rate
LIMIT="200kbit"
#defines the address space for which you wish to disable rate limiting
#LOCALNET="172.31.0.0/16"
LOCALNET="192.168.1.0/24"

#delete existing rules
tc qdisc del dev ${IF} root

#add root class
tc qdisc add dev ${IF} root handle 1: htb default 10

#add parent class
tc class add dev ${IF} parent 1: classid 1:1 htb rate ${LINKCEIL} ceil ${LINKCEIL}

#add our two classes. one unlimited, another limited
tc class add dev ${IF} parent 1:1 classid 1:10 htb rate ${LINKCEIL} ceil ${LINKCEIL} prio 0
tc class add dev ${IF} parent 1:1 classid 1:11 htb rate ${LIMIT} ceil ${LIMIT} prio 1

#add handles to our classes so packets marked with <x> go into the class with "... handle <x> fw ..."
tc filter add dev ${IF} parent 1: protocol ip prio 1 handle 1 fw classid 1:10
tc filter add dev ${IF} parent 1: protocol ip prio 2 handle 2 fw classid 1:11

#limit outgoing traffic to and from port 8333. but not when dealing with a host on the local network
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 8333 ! -d ${LOCALNET} -j MARK --set-mark 0x2
iptables -t mangle -A OUTPUT -p tcp -m tcp --sport 8333 ! -d ${LOCALNET} -j MARK --set-mark 0x2
