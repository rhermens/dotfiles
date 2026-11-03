#!/usr/bin/env bash
S="${*:-$(tmux display-message -p -t "${TMUX_PANE}" '#{session_name}' 2>/dev/null)}"
[ -n "$S" ] && tmux set-option -qu -t "=$S:" @session_notify
true
