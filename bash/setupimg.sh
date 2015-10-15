#!/bin/bash

# This script needs to be run in the same folder as scorer with write perms
# This script is intended to prep the config file for the scorer
# It's a user friendly way to do things
if [ "$1" == "--deploy" ]; then
	echo \#NEWLINE >> /root/.bashrc
	echo alias score\=\"$(pwd)/scorer.sh\" >> /root/.bashrc 
	echo $(pwd)/scorer.sh  >> /root/.bashrc
	echo Deploy done
	exit
fi
if [ "$1" == "--functionality" ]; then
	echo Current functionality:
	curl http://michaelbailey.co/bashscorer
	exit
fi
if [ "$1" == "--testconfig" ]; then
	gucci=1
	cat config.cfg
	if [ "$?" == "1" ]; then
	echo No config file found\? No bueno. Run the script normally.
	gucci=0
		if [ $(base64 --decode config.cfg) != $(base64 --decode config.cfg | strings) ]; then
			echo No valid encoding found
			gucci=0
			exit
		fi
	fi
		if [ "$gucci" != "0" ]; then
			echo GUCCI
		fi
	exit
fi
if [ "$1" == "--viewconfig" ]; then
	echo Here is your config
	base64 --decode config.cfg
	exit
fi
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo Welcome to the GCM Academy Cyber Club scorer
	echo \-\-deploy will set it up to run when you elevate to root or run score
	echo \-\-testconfig will do basic checks \(look for config file, valid base64\)
	echo Running it without a parameter will set up the image
	echo \-\-help or \-h will produce this
	exit
fi
echo Here\'s your current setting\:
cat config.cfg | base64 --decode 
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
echo  \  >> config.precfg
echo  \  >> config.precfg
echo Enter any rogue sudoers \(if they comment it out, it will score as gone\) or done when done
echo -n "roguesudoers=" >> config.precfg
while [ "$sud" != "done" ]; 
do
	read sud
	echo -n $sud, >> config.precfg
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
        echo Score UFW\? \(Y or N\)
        read w
        if [ "$w" == "Y" ]; then
                echo \  >> config.precfg
                echo "scoreufw=1" >> config.precfg 
        fi
clear
	echo Score NOPASSWD rule in sudoers\? \(Y or N \)
	read no
	if [ "$no" == "Y" ]; then
		echo \  >> config.precfg
		echo "scorenopasswd=1" >> config.precfg
	fi
	echo Score TCP SYN Cookies\? \(Y or N \)
	read lmao
	if [ "$lmao" == "Y" ]; then
		echo \  >> config.precfg
		echo "scoretcpsyn=1" >> config.precfg
	fi

base64 config.precfg > config.cfg
rm -rf config.precfg
