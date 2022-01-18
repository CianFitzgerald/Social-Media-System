#!/bin/bash

mkfifo "$1".pipe
if [ $# -le 1 ] || [ $# -ge 6 ]; then 
	echo "Error:Paramaters problem"
	rm -f "$1".pipe
	exit 1

elif [ "$2" = 'create' ] || [ "$2" = 'post' ] || [ "$2" = 'add' ]; then
	echo "$@"  > server.pipe
	read input < "$1".pipe
	echo "$input"
	rm -f "$1".pipe
	exit 0

elif [ "$2" = 'show' ]; then
	echo "$@" > server.pipe
	cat "$1".pipe >> show
	sed -e '2,$!d' -e '$d' show
	rm -f "$1".pipe show

	exit 0

elif [ "$2" = 'shutdown' ]; then
	echo "$@" > server.pipe
	rm -f "$1".pipe
	exit 0
else
	echo "Invalid request"
	rm -f "$1".pipe
	exit 1
fi
