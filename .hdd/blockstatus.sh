#!/bin/bash
#get current block height from blockchain.info
wget https://blockchain.info/latestblock &> /dev/null
sed -n 7p latestblock > line
#cat line
awk -F':' '{print $2}' line > tmp
awk -F',' '{print $1}' tmp > bciblock
echo -n "Current Block: "
cat bciblock
rm tmp
rm latestblock

#get current block from local bitcoin-cli
bash btcinfo.sh &> info 
sed -n 6p info > line1
#cat line1
awk -F':' '{print $2}' line1 > tmp1
awk -F',' '{print $1}' tmp1 > locblock
echo -n "Local Block: "
cat locblock
rm tmp1
rm info
rm line1
echo $(date)
a=$(<bciblock)
b=$(<locblock)
if [ "$b" == "" ]; then
 echo "checking recent blocks.  please wait"
else
diff=$((a-b))
echo "$diff" "blocks behind"
rm bciblock
rm locblock
fi
