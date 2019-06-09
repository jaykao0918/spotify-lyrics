#!/bin/bash
apikey_musixmatch=""
apiurl_musixmatch='http://api.musixmatch.com/ws/1.1/'

# check if spotify is running
ERROR="Spotify is not running! Shutting down......"
status=`pidof spotify | wc -l`
if [ "$status" != 1  ] ; then
    echo "$ERROR"
    exit 1
	#echo "Spotify is running."
fi

#Should check if anything is playing while in loop
while :  
do
	#check if anything is playing, if not then throw an error
	#but there is always something playing in spotify so we'll skip that

	#then if something is playing, use spotify-now to write things into variables
	sp_artist=$("./spotify-now-master/spotify-now -i %artist")
	sp_title=$("./spotify-now-master/spotify-now -i %title")
	sp_unencode_title=$sp_title
	echo "$sp_title - $sp_artist"
	
	#before retrieving lyrics we will use perl to encode and escape variables
	sp_title=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$sp_title")
	sp_artist=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$sp_artist")
	#echo "$sp_title - $sp_artist"

	#use curl to retrieve tracklist from Musixmatch with specified artist and track title
	match_title=$(curl "${apiurl_musixmatch}/track.search?apikey=${apikey_musixmatch}&s_artist_rating=desc&q_artist=$sp_artist&q_track=$sp_title" )
	echo "$match_title"
	track_id=$( "$match_title" | ./jq '.[].body.track_list | .[0].track.track_id')

	#use curl to retireve lyrics from Musixmatch
	match_lyrics=$(curl "${apiurl_musixmatch}/track.lyrics.get?apikey=${apikey_musixmatch}&track_id=$track_id")
  	#-H "'X-RapidAPI-Host:' $apiurl_musixmatch " \
  	#-H "'X-RapidAPI-Key:' $apikey_musixmatch")
	title_lyrics=$("$match_lyrics" | ./jq '.[].body.lyrics.lyrics_body')
	
	echo"$title_lyrics \n"
	#see if in another track if not then sleep
	while [ "$(./spotify-now -i %artist)" != "$sp_unencode_title" ] 
	do
		echo "nothing changes"
		sleep 30s
	done

done