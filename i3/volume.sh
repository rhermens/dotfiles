#!/bin/bash
set -eu
msgTag="volumeNotification"

newvolume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | grep -Eo '[0-9]+' )"

dunstify -a "Volume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$newvolume" "Vol:" 
