#!/usr/bin/env bash

get_service_name() {
  echo "$1" | sed 's/^commonbcs-dcbc-//'
}

export -f get_service_name

container=$(
  docker ps --format "{{.Names}}\t{{.Image}}\t{{.Status}}" |
    fzf \
      --delimiter=$'\t' \
      --with-nth=1,2,3 \
      --height=95% \
      --layout=reverse \
      --border \
      --header="enter: logs | ctrl+e: enter container" \
      --preview 'docker logs --tail 30 {1}' \
      --preview-window=down:35%:wrap \
      --bind 'ctrl-e:execute(
        service=$(get_service_name {1})
        workdir=$(docker inspect --format "{{.Config.WorkingDir}}" {1} 2>/dev/null)
        [ -z "$workdir" ] && workdir="/"
        tmux new-window -n "$service" "exec docker exec -it -w \"$workdir\" {1} bash 2>/dev/null || exec docker exec -it -w \"$workdir\" {1} sh"
      )+abort' |
    cut -f1
)
[ -z "$container" ] && exit 0

service=$(get_service_name "$container")
tmux new-window -n "${service}:logs" \
  "docker logs -f $container 2>&1"
