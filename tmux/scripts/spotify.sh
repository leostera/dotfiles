#!/bin/bash

readonly IS_SPOTIFY_RUNNING=$(
  ps ax \
    | grep "Spotify.app/Contents/MacOS/Spotify" \
    | wc -l
)

if [[ $IS_SPOTIFY_RUNNING -eq 2 ]]; then
  osascript ~/.tmux/scripts/spotify.osascript
fi
