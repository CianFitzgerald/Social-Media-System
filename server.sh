#!/bin/bash

mkfifo server.pipe
while true; do
	read id request arg1 arg2 arg3 < server.pipe
	echo "$request request receieved from client: $id" 
	case "$request" in
		create)
			(./create.sh "$arg1" &) > "$id".pipe 
			
			;;
		add)
			(./add.sh "$arg1" "$arg2" &) > "$id".pipe  

			;;
		post)
			(./post.sh "$arg1" "$arg2" "$arg3" &) > "$id".pipe 
			;;
		show)
			(./show.sh "$arg1" &) > "$id".pipe 
			;;
		shutdown)
			rm -f server.pipe
			break
			exit 0
			;;
		*)
			echo "Error: bad request"
			rm -f server.pipe
			exit 1

	esac
done

