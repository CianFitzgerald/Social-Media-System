#!/bin/bash

lockfile "$1".lock "$2".lock 
if [ $# -le 2 ] || [ $# -ge 4 ]; then
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

elif ! grep -F "$2" "$1"/friends; then
        echo "Error: $2 is not a friend of $1"
        rm -f "$1".lock "$2".lock 
	exit 1

else 
       echo "$2: $3" >> "$1"/wall
       echo "OK: Message posted to wall"
       rm -f "$1".lock "$2".lock 
       exit 0

fi

