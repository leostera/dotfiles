#!/bin/zsh

# For some reason readonly _eats_ the last exit status
SEARCH_RESULTS=$(
  tmux list-window -a \
    -F "#{session_name}:#{window_index} #{window_name} #{pane_current_command} #{pane_current_path}" \
  | column -t \
  | fzf --print-query
)
readonly MATCHED=$?
readonly QUERY=$( echo $SEARCH_RESULTS | cut -d " " -f 1 )
readonly SELECTION=$( echo $SEARCH_RESULTS | cut -d " " -f 1- )

# If we haven't matched anything
if [[ $MATCHED -eq 1 ]]; then
  readonly DIR=$(cat ~/.z | cut -d'|' -f 1 | fzf --query=$SELECTION\$ -1 -0)
  # And this is one of our recent directories
  if [[ ! -z $DIR ]]; then
    # Well let's go in there already!
    tmux new-window -a -n $SELECTION -c $DIR
  fi
# If we have matched on an existing window
elif [[ $MATCHED -eq 0 ]]; then
  readonly TMUX_SELECTOR=$( echo $SELECTION | awk '{ print $1 }' )
  readonly TMUX_SESSION=$( echo $TMUX_SELECTOR | awk -F':' '{ print $1 }')
  readonly TMUX_WINDOW=$( echo $TMUX_SELECTOR | awk -F':' '{ print $2 }')

  # Well let's go in there already!
  tmux switch -t $TMUX_SESSION
  tmux select-window -t $TMUX_WINDOW
fi
