#!/bin/bash
#background script for com between ui and bitcoin.conf
echo -n 0 > /home/linaro/rd_bconf_flag
echo -n 0 > /home/linaro/wr_bconf_flag
/home/linaro/lin_rd_bconf_cron.sh &
/home/linaro/lin_wr_bconf_cron.sh &
