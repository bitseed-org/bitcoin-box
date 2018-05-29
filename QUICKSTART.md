# Using Bitseed 3

Bitseed 3 nodes are delivered with the latest version of bitcoind installed and the blockchain synchronized up to the date of shipment.

Information and updates can be found at https://bitseed.org.

## Basic Use

* Connect the device to your router using the provided Cat5 Ethernet cable.
* Plug in the power adapter and connect to the power port on the device. Push the power button to start.
* Once powered, the device will automatically start bitcoind within 2 hours. Bitcoin will catch up with the current block height and then run continuously, hosting a full bitcoin node.
* The status page will not display at first while bitcoin is verifying the blockchain (5 - 20 minutes).
* The status page may be slow to display while bitcoin is catching up to the current block. The device will work full speed to verify all blocks until present time.
* It is best to keep Bitseed running 24 hours per day.

## Accessing the device

Status and Admin Panel via Browser

* The device has a web browser accessible interface.
* The local network ip address can be discovered by logging into your router and finding the list of network devices. It will have the format  xxx.xxx.xxx.xxx.
  * IP address scanning tools such as Angry IP scanner may be helpful (http://angryip.org).
  * The hostname of the device is “bitseed”.
* The device hosts two web pages:
  * A simple status page on port 80. This page has basic status info and can be displayed publicly. http://[ip.add.re.ss]:80
  * A full admin panel on port 81, which includes menus that allow more detailed status info and controls. This is intended to be kept private. http://[ip.add.re.ss]:81

SSH Access

* You can access the device via SSH.
* **Username and Password are on the bottom of the device.**
* Browse to your router’s control panel to see what IP address the Bitseed device is using. Instructions for accessing your router's control panel are available from your ISP and/or included in the box for your router. The network host name of the device is “btc".
* Linux command line: ssh bitcoin@{paste device IP address here then press enter}
* Putty is a good Windows app for SSH (https://www.putty.org/).
* Windows 10 has an option to add an Ubuntu terminal window. Instructions here: https://docs.microsoft.com/en-us/windows/wsl/install-win10

Direct access via monitor, mouse and keyboard

* The device can be connected to a monitor.
* A USB mouse and USB keyboard can be connected.
* The operating system is Ubuntu Server 16.04, which has no GUI. Command line interface only.

## Shutting down the device

The best way to shutdown the device is to stop bitcoin first. This avoids potential blockchain database corruption and will allow a faster restart.  

**Bitseed Web UI instructions** 

Navigate from the `Home` page via the left menu. Select `Power` and click the `Powerdown Bitseed Device` button. Bitseed will power off within 2 minutes.

**Command line instructions if operating Bitseed via SSH**

Enter the command:

`./btcstop.sh`

Wait until the script says bitcoin has stopped, then enter:

`shutdown -h now`

## System Configuration

* The latest version of Bitcoin Core as of the ship date is installed.
* The system contains a 1TB hard drive, most of which is available for blockchain growth.

## Advanced Use

**Scripts**

The device contains some scripts that may be useful:

`./btcstop.sh` – stop bitcoind

`./btcwatch.sh` – watch dog script, run bitcoind if not running

Bitseed run several scripts automatically. These are initiated via

`crontab -e`

and

`sudo crontab -e`

## Port 8333 for bitcoin peer connections

Bitcoin uses port 8333 to connect with other nodes. To allow other nodes to find your node, Bitcoin Core will attempt to open port 8333 of your router using the UPnP protocol. If UPnP is not enabled in your router, then the node will only have eight peers. If no more than eight peers are connected, check that UPnP is enabled in the router. If UPnP is not supported, you can manually open port 8333 with the router port forwarding controls. Route external port 8333 to port 8333 of the Bitseed node.

## Other notes

* It is best to keep Bitseed running 24/7. If the node is offline for weeks or months, it could take many days for it to catch up with the current block height.
* On rare occasions, a hard shutdown due to a sudden power loss may cause a database corruption. In the event, Bitcoin Core will re-index the blockchain and build a new database. This may take several days to a week to reach the current network block
* Do not unplug the Bitseed from the power cord. Sudden power loss increases the chance that the database will need to rebuild. Use the shutdown button in the web GUI.

_Subscribe to our newsletter at https://bitseed.org/subscribe/ for Bitseed announcements, news, and updates._
