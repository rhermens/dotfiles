#!/usr/bin/env bash

selected=$(find ~ ~/Code -mindepth 1 -maxdepth 1 -type d | fzf --tmux)
selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
