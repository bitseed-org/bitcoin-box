#!/bin/bash
#get current block height from blockchain.info
echo $(date)
wget wget https://blockchain.info/q/getblockcount &> /dev/null
netblk=$(<getblockcount)
echo "Current Block: $netblk"

#get current block from local bitcoin-cli
./bitcoin-cli getblockcount > locblock
nodeblk=$(<locblock)
echo "Local Block: $nodeblk"

#if bitcoin-cli responds, compare local with network blocks
if [ "$nodeblk" == "" ]; then
 echo "checking recent blocks.  please wait"
else
diff=$((netblk-nodeblk))
echo "$diff" "blocks behind"
rm getblockcount
rm locblock
fi
