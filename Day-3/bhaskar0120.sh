#!/bin/bash

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}


ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

sum=0
while IFS= read -r line; do
	len=${#line}
	L=$(($len/2))
	F=${line:0:$L}
	S=${line:$L:$len}
	X=$(tr -dc "$S" <<< "$F")
	if [ ${#X} != 0 ]
	then
		Z=${X:0:1}
		ascii=$(ord $Z)
		if  (($ascii < 91)) 
		then
			sum=$(($sum + $ascii - 38))
		else
			sum=$(($sum + $ascii - 96))
		fi

	fi
done < "./inp.txt" 

echo Easy: $sum

last=""
second_last=""
sum=0
while IFS= read -r line; do
	if [ $second_last ]
	then
		X=$(tr -dc "$last" <<< "$line")
		X=$(tr -dc "$X" <<< "$second_last")
		Z=${X:0:1}
		ascii=$(ord $Z)
		if  (($ascii < 91)) 
		then
			sum=$(($sum + $ascii - 38))
		else
			sum=$(($sum + $ascii - 96))
		fi
		last=""
		second_last=""
		continue
	fi
	second_last=$last
	last=$line
done < "./inp.txt" 
echo Hard: $sum
