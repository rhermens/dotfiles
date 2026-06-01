#!/usr/bin/env bash
S="${1:-$(tmux display-message -p -t "${TMUX_PANE}" '#{session_name}' 2>/dev/null)}"
[[ "$S" == 𝜏* ]] && tmux rename-session -t "$S" "${S#𝜏 }"
true
