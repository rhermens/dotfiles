#!/usr/bin/env bash

set -g mode-style "fg=${fg},bg=${bg}"

set -g message-style "fg=${fg},bg=${bg}"
set -g message-command-style "fg=${fg},bg=${bg}"

set -g pane-border-style "fg=${bg}"
set -g pane-active-border-style "fg=${fg}"

set -g status "on"
set -g status-justify "left"


set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=${fg_dark},bg=${bg_highlight},bold] #S "
set -g status-right "#[fg=${fg_dark},bg=${bg_highlight},bold] λ "
set -g status-style "fg=${fg},bg=default"


setw -g window-status-style "NONE,fg=${fg},bg=${bg},nobold,nounderscore,noitalics"
setw -g window-status-current-style "NONE,fg=${fg_dark},bg=${bg_dark},bold,nounderscore,noitalics"
setw -g window-status-activity-style "underscore,fg=${fg_dark},bg=${bg_dark}"

setw -g window-status-separator ""
setw -g window-status-format "#[default] #I:#W "
setw -g window-status-current-format " #I:#W "

