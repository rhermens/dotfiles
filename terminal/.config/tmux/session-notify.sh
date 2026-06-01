#!/usr/bin/env bash
pid=$$
pane=""
while [ "$pid" -gt 1 ] 2>/dev/null; do
    pane=$(tmux list-panes -a -F "#{pane_id} #{pane_pid}" 2>/dev/null | awk -v p="$pid" '$2==p{print $1;exit}')
    [ -n "$pane" ] && break
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done
S=$(tmux display-message -p -t "${pane:-$TMUX_PANE}" '#{session_name}' 2>/dev/null)
active=$(tmux list-clients -F '#{client_session}' 2>/dev/null)
if ! echo "$active" | grep -qx "$S"; then
    [[ "$S" != 𝜏* ]] && [ -n "$S" ] && tmux rename-session -t "$S" "𝜏 $S"
fi
true
