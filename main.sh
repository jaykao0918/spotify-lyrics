#!/bin/bash

# check if spotify is running
apikey_musixmatch= ''
apiurl_musixmatch = 'http://api.musixmatch.com/ws/1.1/'

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
	match_title=$(curl --get --include "'https://musixmatchcom-	musixmatch.p.rapidapi.com/wsr/1.1/track.search?	s_artist_rating=desc&q_artist='$sp_artist'&q_track='$sp_title"\
  	-H "'X-RapidAPI-Host:' $apiurl_musixmatch " \
  	-H "'X-RapidAPI-Key:' $apikey_musixmatch")
	track_id=$(curl "$match_title" | jq '.[].body.track_list | .[0].track.track_id')

	#use curl to retireve lyrics from Musixmatch
	


	#see if in another track if not then sleep
	while [ "$(./spotify-now -i %artist)" != "$sp_artist" ] 
	do
		echo "nothing changes"
		sleep 30s
	done

done