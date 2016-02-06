#!/usr/bin/env python
# --------------------------------------------------------------------
#  File - lin_wr_bconf_mbox.py
#
#  Written by:    Konn Danley
#  Date:          01/07/2016
#  Purpose:       This script resides in /home/linaro and is used 
#                 to transfer data from wr_bconf_mbox and merge these 
#                 values into .bitcoin/bitcoin.conf
# 
# --------------------------------------------------------------------
import os
import subprocess
import json
import re

json_data=open('wr_bconf_mbox')
wr_mbox_dict_params = json.load(json_data)
param_keys = wr_mbox_dict_params.keys()

fh = open(".bitcoin/bitcoin.conf", "r"); 
lines = fh.readlines()
fh.close()

bitcoin_conf_dict = {}
for line in lines:

    # Skip blank lines
    temp_line = line.strip()
    if temp_line:

		# Skip comments
        if temp_line[0] == '#':
            pass
        else:
            line_key, line_value = temp_line.split("=")
            bitcoin_conf_dict[line_key] = line_value
fh.close()

# Cycle through all of the parameters in wr_mbox_dict_params. Existing 
# values will be replaced and non-existent items will be added
for mbox_key in wr_mbox_dict_params:
    if mbox_key in bitcoin_conf_dict:

        for i in range(len(lines)):
            line = lines[i]
            if line.strip(): 
                if line[0] == '#': 
                    pass
                else:
                    line_key, line_value = line.split("=") 
                    if line_key == mbox_key:
                        temp_str = mbox_key + "=" + str(wr_mbox_dict_params[mbox_key]) + "\n"
                        lines[i] = temp_str 
    else:
        temp_str = mbox_key + "=" + str(wr_mbox_dict_params[mbox_key])
        lines.append(temp_str)

# Make a backup of bitcoin.conf (bitcoin.conf.bak) 
subprocess.call (["cp", "./.bitcoin/bitcoin.conf", 
                  "./.bitcoin/bitcoin.conf.bak"]) 

fh = open("./.bitcoin/bitcoin.conf", "w"); 

for i in range(len(lines)):
    fh.write(lines[i])
fh.close()
