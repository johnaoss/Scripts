#!/usr/bin/env bash

# Initializes an SSH key for GitHub.
# Args: email [keyname]
# Keyname defaults to be `init_key` if not set.

set -e
EMAIL=${1}
KEYNAME=${2:-"init_key"}
KEYPATH="${HOME}/.ssh/${KEYNAME}"

if [[ -z "$1" ]]; then
    echo "Missing email argument, quitting."
    exit 1
fi

if [[ -z "$2" ]]; then 
    echo "Missing keyname parameter, defaulting to init_key"
fi

if [[ -e "$KEYPATH" ]]; then
	echo "File ${KEYPATH} already exists"
	exit 1
fi

echo creating key at ${KEYPATH}
ssh-keygen -t rsa -b 4096 -C ${EMAIL} -f ${KEYPATH} -N "" -q

# check if ssh-agent exists, start if it doesn't
set +e
if ! pgrep "ssh-agent" > /dev/null ; then 
	eval "$(ssh-agent -s)" 
fi
set -e

# create config file if exists (needed as of macOS 10.12)
# need to test
if [[ ! -e "~/.ssh/config" ]]; then 
	cat > ~/.ssh/config <<- EOM
		Host *
  		    AddKeysToAgent yes
		    UseKeychain yes
  		    IdentityFile ~/.ssh/${KEYNAME}
	EOM
fi

ssh-add -K ${KEYPATH}
pbcopy < ${KEYPATH}
echo "Copied key contents to clipboard."

