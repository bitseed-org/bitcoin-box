#set up devide after reflashing nand

rm -rf ~/bitcoin-box
git clone https://github.com/BitSeed-org/bitcoin-box
sudo chmod 755 /home/linaro/bitcoin-box/setup/quickset.sh
cd bitcoin-box/setup

echo "gitclone done" > /home/linaro/bitcoin-box/setup/setup.log

