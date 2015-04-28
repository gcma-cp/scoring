#!/bin/bash

# So it takes config.cfg, decodes it from base64
#(so users can't go "what is this, oh my its the scoring data without it being
# intentional) and checks whatever is next to rogueusers and parses it

#Trigger this when you want to actually score

#Array, static for now but should be imported from CSV in future
rougeUsers=( $(cat config.cfg | base64 --decode | grep rogueusers | sed 's/rogueusers=//g' | sed 's/,/ /g') )
# Rogue user portion
for rougeuser in "${rougeUsers[@]}"
do
	grep :$rougeuser: /etc/passwd &> /dev/null
		if [ $? -ne 0 ];
		then
		echo $rougeuser deleted
		let score=$score+1
		else
		echo DEBUG: $rougeuser still exists
		fi
done
echo Score is $score"00"
