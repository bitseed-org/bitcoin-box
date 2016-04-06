#!/usr/bin/env python
# ----------------------------------------------------------------------------
#  File - lin_rd_launch.py
#
#  Written by:  Konn Danley
#  Date:        12/28/2015
#  Purpose:     This script resides in /home/linaro.  
#               It detects a '1' written to rd_bconf_flag.  
#               If a '1' is detected, then the lin_rd_bconf_mbox.py
#               script will be run.
#
# -----------------------------------------------------------------------------
#
# 
import os
import subprocess

fh = open("./rd_bconf_flag", "r")
line = fh.readline()
if (line.strip() == '1'):
    subprocess.call(["python", "./lin_rd_bconf_mbox.py"])
fh.close()

