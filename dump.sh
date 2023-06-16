#!/bin/bash

# EDIT with "Port Service"
services=(
	"443 MOOZ"
	"18080 biomarkt"
	"1337 cc_market"
	"8000 crashair"
)



GREEN=$(tput setaf 10)
END=$(tput sgr0)

function create_subfolders {
	# create main folder
	mkdir -p /root/pcaps/
	cd /root/pcaps/

	# create services folders
	counter=1
	for service_data in "${services[@]}"; do
		name="service$((counter++))"
		mkdir -p $name
		echo "$GREEN[+] $name$END"
	done

	# grant permissions
	chmod 777 -R .
	
	echo "$GREEN[+] Subfolders Done$END"
}


create_subfolders

counter=1
for service_data in "${services[@]}"; do
	# parse data
	separator=' ' read -ra data <<< "$service_data"
	port=${data[0]}
	service=${data[1]}

	# setup variables
	name="service${counter}_${service}"
	execute="./start_dump_${counter}.sh"
	screen_flags="-S $name -d -m"
	pcap_name="service${counter}_$service-%Y-%m-%d_%H.%M.%S.pcap"
	dump="sudo tcpdump -G 60 -W 30 -w $pcap_name -s0 -i game tcp and port $port"
	cycle_dump="while true; do $dump; sleep 5; done"

	# execute
	cd "service$((counter++))"
	echo "$cycle_dump" > $execute
	chmod +x "$execute"
	screen $screen_flags $execute
	cd ../

	echo "$GREEN[+] $name $END"
done
