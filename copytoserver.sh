#!/bin/bash
set -eo pipefail

if [ "$#" -ne 3 ]; then
	echo "Usage: $0 localfile sshserver serverfilelocation"
	exit 1
fi

dirpath="${1%/*}"
targetname="${1##*/}"

{
if [ -f "$1" ]; then
	tar -cf - -C "$dirpath" "$targetname"
elif [ -d "$1" ]; then
	tar -C "$1" -cf - .
fi
} | ssh "$2" "mkdir -p /tmp/transfer/ '$3'/ && tar -xf - -C /tmp/transfer/"
ssh "$2" -t "sudo mv /tmp/transfer/* '$3'"

