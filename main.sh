#!/bin/bash

# check if spotify is running
ERROR="Spotify is not running! Shutting down......"
status=`pidof spotify | wc -l`
if [[ "$status" != 1  ]]; then
    echo "$ERROR"
else
	echo "Spotify is running."
fi

#Should check if anything is playing while in loop
while true; do
	#check if anything is playing, if not then throw an error

	#then if something is playing, use spotify-now to write things into variables
	echo "Program"
	break


done