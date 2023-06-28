#!/bin/bash

services=(
	"80 a"
)

colors=(
	"#e53935"
	"#d81b60"
	"#8e24aa"
	"#5e35b1"
	"#3949ab"
	"#1e88e5"
	"#039be5"
	"#00acc1"
	"#00897b"
	"#43a047"
	"#7cb342"
	"#9e9d24"
	"#f9a825"
	"#fb8c00"
	"#f4511e"
	"#6d4c41"
)

RANDOM=$$$(date +%s)

for service_data in "${services[@]}"; do
	# parse data
	separator=' ' read -ra data <<< "$service_data"
	port=${data[0]}
	service=${data[1]}

	# choose a random color
	random_index=$((${RANDOM} % ${#colors[@]}))
	color=${colors[ $random_index ]}

	# remove the selected color
	for i in "${!colors[@]}"; do
		if [[ ${colors[i]} = $color ]]; then
			unset 'colors[i]'
		fi
	done
	new_array=()
	for i in "${!colors[@]}"; do
		new_array+=( "${colors[i]}" )
	done
	colors=("${new_array[@]}")
	unset new_array

	# puts the data on server
	content="{\"port\":$port,\"name\":\"$service\",\"color\":\"$color\",\"notes\":\"\"}"
	curl -X PUT "http://localhost:3333/api/services" \
		-H "Content-Type: application/json" \
		-d $content
	echo
done
