#!/bin/bash

path="$1"
time="$2"
address="$3"

print_range(){
	start="$(echo "$1" | awk '{print $4}')"
	end="$(echo "$1" | awk '{print $6}')"
	network="$(echo "$start" | sed 's/\.[0-9]*$//')"
	start_ip="$(echo "$start" | sed 's/.*\.//')"
	end_ip="$(echo "$end" | sed 's/.*\.//')"
	for ip in $(seq $start_ip $end_ip)
	do
		echo "  - normal_check_interval: $time" >> "$path"
		echo "    address: ${network}.${ip}" >> "$path"
		echo "    nrpe_opts: -t 60" >> "$path"
	done
}

if ! [ -f "$path" ]
then
	echo "nrpe_rbl:" > "$path"
fi

mask="$(echo "$address" | sed 's/.*\///')"

if ! echo "$address" | grep -q "/"
then
	echo "  - normal_check_interval: $time" >> "$path"
	echo "    address: $address" >> "$path"
		echo "    nrpe_opts: -t 60" >> "$path"
elif [ $mask -ge 31 ]
then
	echo "  - normal_check_interval: $time" >> "$path"
	echo "    address: $address" | sed 's/\/.*//' >> "$path"
		echo "    nrpe_opts: -t 60" >> "$path"
elif [ $mask -ge 24 ]
then
	print_range "$(sipcalc $address | grep Usable)"
else
	sipcalc $address -s 24 -u | grep Usable | while read line
	do
		print_range "$line"
	done
fi
