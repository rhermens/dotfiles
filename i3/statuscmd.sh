#!/bin/bash

i3status | while :
do
        read line
        echo "$(timer current) $(~/.config/i3/battery.sh)     $line   " || exit 1
done
