#!/bin/bash

__is_input_valid() {
	if [[ "$1" == *"*"* ]] || ! $(echo "$1" | grep -Fxq "*"); then
		return 0
	fi

	return 1
}

__print_deleted_files() {
	local number="${1:-0}"
	local file_indicator="file"
	if [ $number -ne 1 ]; then
		file_indicator="files"
	fi
	echo ""
	echo "$number $file_indicator deleted."
	exit 0
}

# START main
if [ $# -lt 1 ]; then
	echo "$0: You must supply at least one argument."
	exit 1
fi

__is_input_valid $1
if [ $? -eq 1 ]; then
	echo "$0: Your inputs are not valid."
	exit 1
fi

trap "__print_deleted_files 0" SIGINT

path="${2:-.}"
files=$(find $path -type f -name "$1" | sed 's|^./||')

if [ "${#files}" -eq 0 ]; then
	echo "No matching files found."
	exit 1
fi

i=0
for file in $files; do
	read -p "Do you want to delete $file? (y/n) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || continue
	command rm -rf "$file"
	let "i++"
	trap "__print_deleted_files $i" SIGINT
done
#END
