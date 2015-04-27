#!/bin/bash

#Array, static for now but should be imported from CSV in future
rougeUsers=( Rogue1 Rogue2 Rogue3 )
# Rogue user portion
for rougeuser in "${rougeUsers[@]}"
do
	grep $rougeuser /etc/passwd &> /dev/null
		if [ $? -ne 0 ];
		then
		echo $rougeuser deleted
		let score=$score+1
		fi
done
echo Score is $score"00"
