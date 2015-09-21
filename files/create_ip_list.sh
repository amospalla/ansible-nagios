#!/bin/bash

print_range(){
	start="$(echo "$1" | awk '{print $4}')"
	end="$(echo "$1" | awk '{print $6}')"
	network="$(echo "$start" | sed 's/\.[0-9]*$//')"
	start_ip="$(echo "$start" | sed 's/.*\.//')"
	end_ip="$(echo "$end" | sed 's/.*\.//')"
	for ip in $(seq $start_ip $end_ip)
	do
		echo "  - ${network}.${ip}" >> "$path"
	done
}

path="$1"

if [ "$2" = "header" ]
then
	temp="$(mktemp -p /tmp $(basename "$0").XXXXXXXXX)"
	echo "manolo:" > "$temp"
	sort "$path" | uniq >> "$temp"
	mv "$temp" "$path"
elif [ "$2" = "address" ]
then
	mask="$(echo "$3" | sed 's/.*\///')"
	if ! echo "$3" | grep -q "/"
	then
		echo "  - $3" >> "$path"
	elif [ $mask -ge 31 ]
	then
		printf "  - " >> "$path"
		echo "$3" | sed 's/\/.*//' >> "$path"
	elif [ $mask -ge 24 ]
	then
		print_range "$(sipcalc $3 | grep Usable)"
	else
		sipcalc $3 -s 24 -u | grep Usable | while read line
		do
			print_range "$line"
		done
	fi
fi
