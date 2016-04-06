#!/usr/bin/env python
# ----------------------------------------------------------------------------
#  File - lin_wr_launch.py
#
#  Written by:  Konn Danley
#  Date:        01/01/2016
#  Purpose:     This script resides in /home/linaro.  
#               It detects a '1' written to wr_bconf_flag.  
#               If a '1' is detected, then the lin_wr_bconf_mbox.py
#               script will be run.
#
# -----------------------------------------------------------------------------
#
# 
import os
import subprocess

fh = open("./wr_bconf_flag", "r")
line = fh.readline()
fh.close()
print line
if (line.strip() == '1'):
    # ----------------------------------------------------------
    # We only want .bitcoin/bitcoin.conf to be written one time
    # We must turn off the operation after that by writing a '0'
    # to wr_bconf_flag  
    # ----------------------------------------------------------
    fh = open("./wr_bconf_flag", "w")
    fh.write("0")
    fh.close()

    subprocess.call(["python", "./lin_wr_bconf_mbox.py"])
    print "made it"

