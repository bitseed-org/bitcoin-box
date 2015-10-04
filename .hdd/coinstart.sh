#which coin are we running?
coin=$( < $HOME/coin)
echo "$coin"
coincli="$coin""-cli"
coind="$coin""d"
coindir=".""$coin"
coinconf="$coin"".conf"

./coinwatch.sh
