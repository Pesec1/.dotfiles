#!/usr/bin/env bash

set -u

session_id=$(tmux display-message -p '#{session_id}')
current_window_id=$(tmux display-message -p '#{window_id}')

windows=$(
    tmux list-windows -t "$session_id" \
        -F $'#{window_id}\t#{window_index}\t#{window_name}\t#{pane_current_command}\t#{window_panes}' |
        while IFS=$'\t' read -r window_id index name command panes; do
            [[ "$window_id" == "$current_window_id" ]] && continue
            printf '%s\t%s\t%s\t%s\t%s pane%s\n' \
                "$window_id" "$index" "$name" "$command" "$panes" \
                "$([[ "$panes" == 1 ]] && printf '' || printf 's')"
        done
)

if [[ -z "$windows" ]]; then
    tmux display-message 'No other windows to close in this session'
    exit 0
fi

selection=$(
    printf '%s\n' "$windows" |
        fzf --multi \
            --delimiter=$'\t' \
            --with-nth=2.. \
            --prompt='Close windows> ' \
            --header='TAB: select multiple  ENTER: close  ESC: cancel' \
            --preview='tmux capture-pane -ep -t {1} -S -1000' \
            --preview-window='right,60%,wrap' \
            --border=rounded
) || exit 0

[[ -z "$selection" ]] && exit 0

while IFS=$'\t' read -r window_id _; do
    tmux unlink-window -k -t "$session_id:$window_id"
done <<< "$selection"

tmux move-window -r -t "$session_id"
