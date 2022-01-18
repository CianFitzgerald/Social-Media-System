#!/bin/bash
lockfile "$1".lock
if [ $# -eq 0 ] || [$# -ge 2]; then
	echo "Error: parameters problem"
	rm -f "$1".lock
	exit 1

elif [ -d "$1" ]; then
	echo "Error: $1 already exists"
	rm -f "$1".lock
	exit 1

else 
	mkdir "$1"
	touch "$1"/wall "$1"/friends
	echo "OK: $1 created"
	rm -f "$1".lock
	exit 0

fi

