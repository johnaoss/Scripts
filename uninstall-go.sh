#!/usr/bin/env bash

# uninstalls Go 

if ! which go > /dev/null; then
    echo "Go isn't installed, or is not in your $PATH."
    exit 1
fi

sudo rm -rf /usr/local/go/
if [[ -f "/etc/paths.d/go" ]]; then
    sudo rm /etc/paths.d/go
fi
