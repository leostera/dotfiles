#!/bin/bash

readonly SELECTION=$(
  tmux list-window -a \
    -F "#{session_name}:#{window_index} #{window_name} #{pane_current_path}" \
  | column -t \
  | fzf
)

readonly TMUX_SELECTOR=$( echo $SELECTION | awk '{ print $1 }' )
readonly TMUX_SESSION=$( echo $TMUX_SELECTOR | awk -F':' '{ print $1 }')
readonly TMUX_WINDOW=$( echo $TMUX_SELECTOR | awk -F':' '{ print $2 }')

tmux switch -t $TMUX_SESSION
tmux select-window -t $TMUX_WINDOW
