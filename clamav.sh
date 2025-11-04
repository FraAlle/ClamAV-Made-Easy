#!/bin/bash

#Installation Time

#Download the .deb file
url="https://www.clamav.net/downloads/production/clamav-1.4.3.linux.x86_64.deb"

file_name=$(basename "$url")

wget -P ~/Download "$url"

#Install ClamAV
cd ~/Download && sudo apt install ./"$file_name"

#Get Day Time
date=$(date +'%d-%m-%Y')

#Directories declaration
directory_to_check="/home/fran/Desktop/Cybersecurity"
log_path="/home/fran/Desktop/clamav-log/log_$date.txt"

#Base Command
base_command="clamscan -r"

#Command
command="$base_command $directory_to_check"

echo "Starting ClamAV scan in directory $directory_to_check."

if output=$(eval "$command"); then
	#Important variables from the output command
	output=$(echo "$output" | tail -n 11)
	infected=$(echo "$output | grep Infected | grep -o '[0-9]\+'")
	#Send Out information
	echo "$output" > "$log_path"
	echo "Scan successful. The log is saved at $log_path"
	#Send Notification to the system
	notify-send "Antivirus Automated Scan completed. $infected files infected found."
	
else
	echo "The command got some problems."
	notify-send "ClamAV scan run out in a problem."
fi
