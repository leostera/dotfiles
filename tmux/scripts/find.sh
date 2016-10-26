#!/bin/bash

readonly SEARCH_OPTIONS=$HOME/.tmux/.search_options

tmux list-window -a \
  -F "#{session_name}:#{window_index} #{window_name} #{pane_current_command} #{pane_current_path}" \
  > $SEARCH_OPTIONS

cat ~/.z | cut -d'|' -f 1 | sort | uniq | sed 's/^/-:- - - /' >> $SEARCH_OPTIONS

# For some reason readonly _eats_ the last exit status
SEARCH_RESULTS=$(
  cat $SEARCH_OPTIONS \
  | column -t \
  | fzf --print-query
)
readonly MATCHED=$?
readonly QUERY=$( echo $SEARCH_RESULTS | cut -d " " -f 1 )
readonly SELECTION=$( echo $SEARCH_RESULTS | cut -d " " -f 1- )

if [[ $MATCHED -eq 0 ]]; then
  readonly TMUX_SELECTOR=$( echo $SELECTION | awk '{ print $2 }' )
  readonly TMUX_SESSION=$( echo $TMUX_SELECTOR | awk -F':' '{ print $1 }' )
  readonly TMUX_WINDOW=$( echo $TMUX_SELECTOR | awk -F':' '{ print $2 }' )

  readonly TMUX_PATH=$( echo $SELECTION | awk '{ print $NF }' )
  readonly TMUX_WINDOW_NAME=$(basename $TMUX_PATH)

  if [[ "$TMUX_WINDOW" == "-" ]]; then
    tmux new-window -a -n $TMUX_WINDOW_NAME -c $TMUX_PATH
  else
    tmux switch -t $TMUX_SESSION
    tmux select-window -t $TMUX_WINDOW
  fi
fi
