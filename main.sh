#!/bin/bash

# check if spotify is running
ERROR="Spotify is not running! Shutting down......"
status=`pidof spotify | wc -l`
if [ "$status" != 1  ] ; then
    echo "$ERROR"
    exit 1
	#echo "Spotify is running."
fi

#Should check if anything is playing while in loop
while true; do
	#check if anything is playing, if not then throw an error
	#but there is always something playing in spotify so we'll skip that

	#then if something is playing, use spotify-now to write things into variables
	sp_artist=$(./spotify-now -i %artist)
	sp_title=$(./spotify-now -i %title)
	echo "$sp_title - $sp_artist"
	#before retrieving lyrics we will use perl to encode and escape variables
	sp_title=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$sp_title")
	sp_artist=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$sp_artist")
	#echo "$sp_title - $sp_artist"

	#use curl to retrieve tracklist from Musixmatch with specified artist and track title

	#use curl to retireve lyrics from Musixmatch
	


	#see if in another track if not then sleep
	while [ "$(./spotify-now -i %artist)" != "$sp_artist" ] 
	do
		echo "nothing changes"
		sleep 30s
	done

done