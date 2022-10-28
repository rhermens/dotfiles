#!/bin/bash
# Based on https://github.com/sandeel/i3-new-workspace
# Script occupies free workspace with lowest possible number
# Add -m as an argument to move current container to the next workspace

# Enable strict mode
set -euo pipefail

# Use swaymsg if WAYLAND_DISPLAY is set
msg_cmd=${WAYLAND_DISPLAY+swaymsg}
msg_cmd=${msg_cmd:-i3-msg}

ws_json=$($msg_cmd -t get_workspaces)
for i in {1..10} ; do
    [[ $ws_json =~ \"num\":\ ?$i ]] && continue

    echo $i;
    break;
done
