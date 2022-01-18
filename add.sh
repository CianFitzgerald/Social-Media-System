#!/bin/bash

lockfile "$1".lock "$2".lock	
if [ $# -le 1 ] || [ $# -ge 3 ]; then
        echo "Error: parameters problem"
	rm -f "$1".lock "$2".lock
        exit 1

elif [ ! -d "$1" ]; then
        echo "Error: $1 does not exist"
        rm -f "$1".lock "$2".lock
	exit 1

elif [ ! -d "$2" ]; then
	echo "Error: $2 does not exist"
	rm -f "$1".lock "$2".lock
	exit 1

elif grep -F "$2" "$1"/friends; then
        echo "Error: $1 already friends with this user"
        rm -f "$1".lock "$2".lock
	exit 1

else 
       	echo "$2" >> "$1"/friends
        echo "OK: $2 added"
        rm -f "$1".lock "$2".lock
	exit 0
	
fi

