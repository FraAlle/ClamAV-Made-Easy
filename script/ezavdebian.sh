#!/bin/bash

echo "
 _______  _______    _______             ______   _______  ______  _________ _______  _       
(  ____ \/ ___   )  (  ___  )|\     /|  (  __  \ (  ____ \(  ___ \ \__   __/(  ___  )( (    /|
| (    \/\/   )  |  | (   ) || )   ( |  | (  \  )| (    \/| (   ) )   ) (   | (   ) ||  \  ( |
| (__        /   )  | (___) || |   | |  | |   ) || (__    | (__/ /    | |   | (___) ||   \ | |
|  __)      /   /   |  ___  |( (   ) )  | |   | ||  __)   |  __ (     | |   |  ___  || (\ \) |
| (        /   /    | (   ) | \ \_/ /   | |   ) || (      | (  \ \    | |   | (   ) || | \   |
| (____/\ /   (_/\  | )   ( |  \   /    | (__/  )| (____/\| )___) )___) (___| )   ( || )  \  |
(_______/(_______/  |/     \|   \_/     (______/ (_______/|/ \___/ \_______/|/     \||/    )_)"

#Get Day Time
date=$(date +'%d-%m-%Y')

#Directories declaration
directory_to_check="/folder/to/control" #Change the directory to check

log_path="/where/the/log/is/located/log_$date.txt" #Change this directory to save the log

#Put the directory where the script is located
script_location="/change/this/directory/ezavdebian.sh" #Change this directory to the script location

#Base Command
base_command="clamscan -r"

#Command
command="$base_command $directory_to_check"


#Installation Time

#Check if ClamAV is already installed
if ! installed=$(dpkg -l | grep clamav); then

	#Download the .deb file
	url="https://www.clamav.net/downloads/production/clamav-1.4.3.linux.x86_64.deb"

	file_name=$(basename "$url")

	wget -P ~/Download "$url"

	#Install ClamAV
	cd ~/Download && sudo apt install ./"$file_name"
else
	echo "Package already installed"

fi

echo "Starting ClamAV scan in directory $directory_to_check."

if output=$(eval "$command"); then

	#Important variables from the output command
	output=$(echo "$output" | tail -n 11)
	infected=$(echo "$output" | grep Infected | grep -o '[0-9]\+')
	

	#Send Out information
	echo "$output" >> "$log_path"
	echo "Scan successful. The log is saved at $log_path"

	#Send Notification to the system
	notify-send "Antivirus Automated Scan completed. $infected files infected found."
	
else
	echo "The command got some problems."
	notify-send "ClamAV scan run out in a problem."
fi

#Get user response
echo "By default, you can create a cronjob to run this script every 12 hours."
read -p "Do you want to create a cronjob?(Y/N)" answer

#In case you want to create a Cronjob
if [[ "$answer" == "Y" || "$answer" == "y"  ]]; then
	
	#Move the file into crond.daily folder
	echo "0 */12 * * * root ~/Desktop/Ez-Av-Debian/ezavdebian.sh" | sudo tee -a /etc/crontab > /dev/null
	echo "Cronjob created successfully. See ya."

else
	echo "Cronjob not created. See ya."
fi
exit 0