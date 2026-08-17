#!/usr/bin/env bash
W="${1:-$(tmux display-message -p -t "${TMUX_PANE}" '#{window_id}' 2>/dev/null)}"
[ -n "$W" ] && tmux set-option -wqu -t "$W" @notify
true
