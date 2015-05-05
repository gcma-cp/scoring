
#!/bin/bash

# So it takes config.cfg, decodes it from base64
#(so users can't go "what is this, oh my its the scoring data without it being
# intentional) and checks whatever is next to rogueusers and parses it

#Trigger this when you want to actually score

#Array, static for now but should be imported from CSV in future
rougeUsers=( $(cat config.cfg | base64 --decode | grep rogueusers | sed 's/rogueusers=//g' | sed 's/,/ /g') )
potential=0
# Rogue user portion
for rougeuser in "${rougeUsers[@]}"
do
	grep $rougeuser: /etc/passwd &> /dev/null
		if [ $? -ne 0 ];
		then
		echo $rougeuser deleted
		let score=$score+1
		# else
		#   echo DEBUG: $rougeuser still exists
		fi
			let potential=$potential+1
done
#And now services
rougeservs=( $(cat config.cfg | base64 --decode | grep rogueservs | sed 's/rogueservs=//g' | sed 's/,/ /g') )
# Rogue user portion
for rougeservice in "${rougeservs[@]}"
do
	service $rougeservice status > /dev/null
		if [ $? -ne 0 ];
		then
			echo $rougeservice stopped
			let score=$score+1
		# else
		#	echo DEBUG: $rougeservice still exists
		fi
			let potential=$potential+1
done
cat config.cfg | base64 --decode | grep "scorex11=1" &> /dev/null
if [ "$?" -eq "0" ]; then
	grep -i "X11Forwarding yes" /etc/ssh/sshd_config &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo X11 forwarding disabled
		let score=$score+1
	fi
		let potential=$potential+1
fi
cat config.cfg | base64 --decode | grep "scoreprotocol=1" &> /dev/null
if [ "$?" -eq "0" ]; then
	grep -i "Protocol" /etc/ssh/sshd_config | grep "1" &> /dev/null
	if [ "$?" -ne "0" ]; then
		echo SSH Protocol option set properly
		let score=$score+1
	fi
		let potential=$potential+1
fi
cat config.cfg | base64 --decode | grep "scorepermrootlogin=1" &> /dev/null
if [ "$?" -eq "0" ]; then
	grep -i "PermitRootLogin no" /etc/ssh/sshd_config &> /dev/null
	if [ "$?" -eq "0" ]; then
		echo PermitRootLogin disabled. Thank God.
		let score=$score+1
	fi
		let potential=$potential+1
fi

#And now aliases
rougealias=( $(cat config.cfg | base64 --decode | grep roguealias | sed 's/roguealias\=//g' | sed 's/,/\ /g'  ))
# Rogue alias portion
for rougealia in "${rougealias[@]}"
do
        alias | grep $rougealia\=
                if [ $? -ne 0 ];
                then
                        echo $rougealia alias cancelled
                        let score=$score+1
                fi
			let potential=$potential+1
done
#And package time
rougepkg=( $(cat config.cfg | base64 --decode | grep roguepackages | sed 's/roguepackages\=//g' | sed 's/,/\ /g'))
# Rogue package  portion
for rougepackg in "${rougepkg[@]}"
do
		echo \ $rougepackg\ 
        dpkg -l | grep \ $rougepackg\  > /dev/null
                if [ $? -ne 0 ];
                then
                        echo $rougepackg purged
                        let score=$score+1
                fi
		let potential=$potential+1
done
cat config.cfg | base64 --decode | grep "scoreufw=1" &> /dev/null
if [ "$?" -eq "0" ]; then
	ufw status | grep "Status: active"
	if [ "$?" -eq "0" ]; then
		echo UFW is active
		let score=$score+1
	fi
	let potential=$potential+1
fi

echo Score is $score"00" out of $potential"00"
