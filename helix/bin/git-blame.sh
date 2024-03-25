#!/usr/bin/env bash

TMP_FILE=/tmp/helix-screen

# dump current screen to tmp file
zellij action dump-screen $TMP_FILE 

# Capture the output of the original pane
PANE_OUTPUT=$(cat $TMP_FILE)

# clean temp file
# rm $TMP_FILE

# Extract file and line information
REGEX="\s+(?:NORMAL|INSERT|SELECT)\s+\S*\s╎\s*(\S*)\s*╎\s*(\d+):(\d+)"
FILE=$(echo $PANE_OUTPUT | rg -e $REGEX -o --replace '$1')
LINE=$(echo $PANE_OUTPUT | rg -e $REGEX -o --replace '$2')

# Run git blame and fzf commands in floating pane
zellij run --floating --close-on-exit -- git blame $FILE
zellij action write-chars "$LINE"
zellij action write 13
