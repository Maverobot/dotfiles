#!/usr/bin/env bash
# This scripts runs a command repeatedly until it fails. During execution, it should write the number of the current iteration to a file, /tmp/run_until_fail_count

set -e # Exit on error

function write_count_to_file() {
    echo "${command[*]} : $count" > "$countfile"
}

# The command to run (remainder of the script arguments)
command=("$@")

# The file to write the current iteration to
countfile=/tmp/run_until_fail_count

# The number of the current iteration
count=0

# Run the command until it fails
write_count_to_file
while "${command[@]}"; do
    # Increment the iteration number
    count=$((count + 1))
    # Write the iteration number to the count file
    write_count_to_file
done
