#watch the mempool size
#restart if it gets too big
./bitcoin-cli getmempoolinfo > mempool
byt=$(cat mempool | jq '.bytes')
echo "$byt"
if [ "$byt" -gt "180000000" ]; then
 echo "$(date) mempool is $byt, restarting" >> cron.log
 echo 1 > $HOME/restartflag
 echo 0 > mempool
fi
