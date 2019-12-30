#!/usr/bin/env bash

set -eu

regex='((https?|ftp|file|git)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|])'
BUFFER_NAME=temp-buffer
# capture buffer
tmux capture-pane -b $BUFFER_NAME 

content=`tmux show-buffer -b $BUFFER_NAME`

# delete buffer
tmux delete-buffer -b $BUFFER_NAME

parts=$(echo $content | tr ' ' '\n')

output=""
for match in $parts; do
    [[ $match =~ $regex ]]
    url=${BASH_REMATCH[1]-""}
    if [[ -n $url ]]; then
        output="$output $url"
    fi 
done

if [[ -z $output ]]; then
    echo "[Info] No url found in current pane"
else
    echo $output | tr ' ' '\n' | sort | uniq
fi 
