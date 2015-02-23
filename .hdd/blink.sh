#blinks tx and rx leds
while true
do
echo 1 > /sys/devices/virtual/misc/gpio/pin/gpio18
echo 0 > /sys/devices/virtual/misc/gpio/pin/gpio19
sleep 1
echo 0 > /sys/devices/virtual/misc/gpio/pin/gpio18
echo 1 > /sys/devices/virtual/misc/gpio/pin/gpio19
sleep 1
done
