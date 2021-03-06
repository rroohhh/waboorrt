#!/bin/bash

while true; do
  inotifywait -e create /botbuilder;
  while [ -n "$(ls /botbuilder/)" ]; do
    file=$(find /botbuilder/ -type f -exec basename {} \; | head -n1);

    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR" || exit
    echo "Building bot $file"
    git clone "/git/$file.git" .
    docker build -t "localhost/bot/$file" .
    redis-cli -h redis set "user:$file" "{\"botname\": \"$file\"}"
    cd "$HOME" || exit

    rm "/botbuilder/$file";
    done;
done
