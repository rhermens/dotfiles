#!/usr/bin/env bash
pid=$$
pane=""
while [ "$pid" -gt 1 ] 2>/dev/null; do
	pane=$(tmux list-panes -a -F "#{pane_id} #{pane_pid}" 2>/dev/null | awk -v p="$pid" '$2==p{print $1;exit}')
	[ -n "$pane" ] && break
	pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done
W=$(tmux display-message -p -t "${pane:-$TMUX_PANE}" '#{window_id}' 2>/dev/null)
active=$(tmux list-clients -F '#{window_id}' 2>/dev/null)
if ! echo "$active" | grep -qx "$W"; then
	[ -n "$W" ] && tmux set-option -wq -t "$W" @notify 1
fi
true
