#!/bin/bash

__check_input_validity() {
    local strlen=${#1}
    local digits=${#2}

    if [[ "$1" =~ ^[a-z]+$ ]] && [[ "$2" =~ ^[0-9]+$ ]]; then
    	if [ $strlen -eq $digits ]; then
    	    return 0
    	elif [ $strlen -ne $digits ] && [ $digits -eq 1 ]; then
    	    return 0
    	fi
    fi

    return 1
}

__cipher() {
	local result=()

	for ((i=0; i < ${#1}; i++)); do
		local char=$(printf '%d' "'${1:i:1}")

		local digit=${2:0:1}
		if [ ! -z "${2:i:1}" ]; then
			digit=${2:i:1}
		fi

		local new=$(expr $(expr $(expr $(expr $char + $digit) - 97) % 26) + 97)
		result[$i]=$(printf \\$(printf '%03o' $new))
	done
	
	echo $(echo "${result[@]}" | tr -d " ")
}

		
# START main
if [ $# -ne 2 ]; then
    echo "$0: You must supply a string with an integer with at least one digit or the same length as the string.";
    exit 1
fi

__check_input_validity $1 $2
if [ $? -ne 0 ]; then
    echo "$0: Your inputs are not valid."
    exit 1
fi

__cipher $1 $2
# END
