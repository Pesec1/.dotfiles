#!/usr/bin/env bash

# CONFIG: directories to scan
DIRS="/var/hosting/"
DIRS2="/var/hosting/common.bcs-dc.bc/sources/mtvn"
DIRS3="/var/hosting/common.bcs-dc.bc/sources/id"
CUSTOM="$HOME/.config/tmux/tmux_custom"

# Collect dirs from given folders
choices=$(find $DIRS $DIRS2 $DIRS3 -maxdepth 1 -mindepth 1 -type d 2>/dev/null)

# Add custom paths file if it exists
[ -f "$CUSTOM" ] && choices="$choices
$(cat "$CUSTOM")"

# Show dmenu
selection=$(printf '%s\n' $choices | fzf --prompt="Select project dir> " --height=40%)

# Exit if nothing selected
[ -z "$selection" ] && exit 0

# Session name (safe: basename, no slashes)
session_name=$(basename "$selection" | tr -c '[:alnum:]' '_')



# If session exists, attach or switch
if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux switch-client -t "$session_name" 2>/dev/null || tmux attach -t "$session_name"
else
    tmux new-session -ds "$session_name" -c "$selection"
    tmux switch-client -t "$session_name"
fi
