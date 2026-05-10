#!/usr/bin/env bash

selected=$(git worktree list | fzf --tmux --print-query)
[[ -z $selected ]] && exit 0

selected_path=$(echo "$selected" | awk '{print $1}')
selected_name=$(basename "$selected_path" | tr . _)

if ! [ -e $selected_path ]; then
    git worktree add -b "$selected_name" "$selected_path"
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected_path" \; new-window -c "$selected_path" \; new-window -c "$selected_path" \; new-window -c "$selected_path" \; new-window -c "$selected_path"
fi

tmux switch-client -t "$selected_name"
