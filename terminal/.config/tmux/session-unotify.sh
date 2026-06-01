#!/usr/bin/env bash
S="${*:-$(tmux display-message -p -t "${TMUX_PANE}" '#{session_name}' 2>/dev/null)}"
[[ "$S" == 𝜏* ]] && tmux rename-session -t "$S" "${S#𝜏 }"
true
