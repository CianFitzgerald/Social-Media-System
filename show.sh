#!/bin/bash
lockfile "$1".lock
if [ $# -eq 0 ] || [ $# -ge 2 ]; then
         echo "Error: parameters problem"
         rm -f "$1".lock
	 exit 1

elif [ ! -d "$1" ]; then
         echo "Error: $1 does not exist"
	 rm -f "$1".lock
         exit 1

else	
	echo "WallStart"
        cat "$1"/wall
	echo "WallEnd"
	rm -f "$1".lock
        exit 0

fi




