#!/bin/sh

# This script needs to be run in the same folder as scorer with write perms
# This script is intended to prep the config file for the scorer
# It's a user friendly way to do things

echo Enter any rogue users you want to score, or alternatively \"done\" when done.
echo -n "rogueusers=" > config.precfg
while [ "$p" != "done" ]
do
	echo Rogue user username: 
	read p
	if [ "$p" != "done" ];
	then
		echo -n $p, >> config.precfg
	fi
done
base64 config.precfg > config.cfg
rm -rf config.precfg
