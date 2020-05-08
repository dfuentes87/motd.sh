#!/bin/bash

# get OS and kernel info (supports old OSs)
if [ -f /etc/os-release ]; then
  OS_NAME="$(awk -F'"' '/PRETTY_NAME/ {print $2}' /etc/os-release) ($(uname -r))"
elif [ -f /etc/system-release ]; then
  OS_NAME="$(cat /etc/system-release) ($(uname -r))"
else
  OS_NAME="$(awk -F'=' '/DISTRIB_DESCRIPTION/ {print $2}' /etc/lsb-release | sed 's/"//g') ($(uname -r))"
fi

# get uptime
UPTIME_DAYS=$(expr `cat /proc/uptime | cut -d '.' -f1` / 86400)
UPTIME_HOURS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 86400 / 3600)
UPTIME_MINUTES=$(expr `cat /proc/uptime | cut -d '.' -f1` % 86400 % 3600 / 60)

# get load avgs (1 min/5 min/15 min)
read one five fifteen rest < /proc/loadavg

# output (with color!)
echo "
 $( hostname | tr 'a-z' 'A-Z')
 $(tput setaf 1)$OS_NAME

 $(tput setaf 2)Uptime.....: $(tput sgr0)$UPTIME_DAYS days, $UPTIME_HOURS hrs, $UPTIME_MINUTES mins
 $(tput setaf 2)Load Avg...: $(tput sgr0)${one}, ${five}, ${fifteen} $(tput setaf 1)($(nproc --all) cores)

$(tput setaf 2)$(df -h | head -n1 | sed -e 's/^/ /')
$(tput sgr0)$(df -h | grep -e '^\/dev' | sed -e 's/^/ /')

 $(tput setaf 2)           $(free -m | head -1 | tr -s ' ' | cut -d' ' --output-delimiter=$'\t' -f1-4,6)
 $(tput setaf 2)Memory.......: $(tput sgr0)$(free -m | sed -n '2 p' | tr -s ' ' | cut -d' ' --output-delimiter=$'\t' -f2-4,6)
 $(tput setaf 2)Swap.........: $(tput sgr0)$(free -m | grep 'Swap' | tr -s ' ' | cut -d' ' --output-delimiter=$'\t' -f2-4,6)

 $(tput setaf 2)IP Address(es).......: $(tput sgr0)$(ip a | awk '/glo/ {print $2}' | cut -f1 -d/ | sort -n | xargs | sed 's/ / | /g')
 $(tput sgr0)" | sed 's/\$//g' #remove old OS version nonsense
