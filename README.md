# server_stats.sh
A bash script which can be set to run on login to quickly see important server stats in order to ground yourself when beginning to troubleshoot issues.

The script will output the following:

hostname  
OS version (kernel)

uptime days, hours, mins  
load averages 1/5/15

disk free (df) for /dev/ filesystems

free -m

IPv4 address(es)