#!/bin/bash

readonly IS_SPOTIFY_RUNNING=$(
  ps ax \
    | grep "Spotify.app/Contents/MacOS/Spotify" \
    | wc -l
)

if [[ $IS_SPOTIFY_RUNNING -eq 2 ]]; then
  readonly NOW_PLAYING=$(osascript ~/.tmux/scripts/spotify.osascript)
  echo "🔊  ${NOW_PLAYING}" \
    | awk 'length > 40 { $0=substr($0,0,41)"..." }1'
fi
