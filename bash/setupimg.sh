#!/bin/bash

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
clear
echo Enter any rogue services you want to score, or alternatively done when done. PLEASE USE THE SERVICE NAME AS IT APPEARS IN service --status-all
echo \  >> config.precfg
echo \  >> config.precfg
echo -n "rogueservs=" >> config.precfg
while [ "$q" != "done" ]
do
        echo Rogue service name: 
        read q
		service $q status &> /dev/null
		if [ "$?" -ne "0" ]; then
			if [ "$q" != "done" ]; then
				echo Service is not currently running as you wrote it \($q\). Still wrote to config however.
			fi
		fi 
        if [ "$q" != "done" ];
        then
                echo -n $q, >> config.precfg
        fi
done
clear
echo Do you want to configure SSH configuration server scoring \(Y or N\)
read z
if [ "$z" == "Y" ];
then
	echo Score Protocol option\? \(Y or N\)
	read a
	if [ "$a" == "Y" ]; then
		echo \  >> config.precfg
		echo "scoreprotocol=1" >> config.precfg	
	fi
	echo Score X11Forwarding Option\? \(Y or N\)
	read b
	if [ "$b" == "Y" ]; then
		echo \  >> config.precfg
		echo "scorex11=1" >> config.precfg
	fi 
	echo Score PermitRootLogin option\? \(Y or N\)
	read c
	if [ "$c" == "Y" ]; then
		echo \ >> config.precfg
		echo "scorepermrootlogin=1" >> config.precfg
	fi
else
	echo Okay, moving on then
fi
clear
echo Enter any rogue aliases \(the base only\, so only what\'s before the \= when you aliased it\) you want to score\, or alternatively \"done\" when done
echo \  >> config.precfg
echo -n "roguealias=" >> config.precfg
while [ "$r" != "done" ]
do
        echo Rogue alias: 
        read r
        if [ "$r" != "done" ];
        then
                echo -n $r, >> config.precfg
        fi
done
clear
echo Enter package name \(not exclusive, if you enter the name apache and apache2 is installed, it\'ll score for apache so long as apache2 exists\)
echo Or enter done when done
echo \  >> config.precfg
echo -n "roguepackages=" >> config.precfg
while [ "$f" != "done" ]
do
        echo Rogue packages: 
        read f
        if [ "$f" != "done" ];
        then
                echo -n $f, >> config.precfg
        fi
done
clear


base64 config.precfg > config.cfg
rm -rf config.precfg
