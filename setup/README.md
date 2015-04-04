These scripts prepare and configure the device before bitcoin is installed

devicesetup.sh updates and prepares the device and mounts the hard disk

btcsetup.sh installs all bitcoin dependecies

setup scripts need to be run as sudo

    cd ~/bitcoin-box
    sudo ./devicesetup.sh
    sudo ./btcsetup.sh
    sudo ./crontabsetup.sh
