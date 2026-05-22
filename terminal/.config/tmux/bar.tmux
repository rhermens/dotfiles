#!/usr/bin/env bash

set -g mode-style "fg=${fg},bg=${bg}"

set -g message-style "fg=${fg},bg=${bg}"
set -g message-command-style "fg=${fg},bg=${bg}"

set -g pane-border-style "fg=${bg}"
set -g pane-active-border-style "fg=${fg}"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=${fg},bg=${bg_dark}"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=${black},bg=${fg},bold] #S #[fg=${fg},bg=${bg_dark},nobold,nounderscore,noitalics]"
set -g status-right "#[fg=${black},bg=${fg},bold] λ "


setw -g window-status-activity-style "underscore,fg=${fg_dark},bg=${bg_dark}"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=${fg_dark},bg=${bg_dark}"

setw -g window-status-format "#[fg=${bg_dark},bg=${bg_dark},nobold,nounderscore,noitalics]#[default] #I:#W #[fg=${bg_dark},bg=${bg_dark},nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=${bg_dark},bg=${bg},nobold,nounderscore,noitalics]#[fg=${fg},bg=${bg},bold] #I:#W #[fg=${bg},bg=${bg_dark},nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#1f2335] #[fg=#1f2335]#[bg=#e0af68]"
set -g @prefix_highlight_output_suffix " "
