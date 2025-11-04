# ClamAV-Made-Easy
Script wrote in bash to Download and Setup ClamAV.

The script download the last LTS version from the web page of ClamAV and install it, only in the case you don't have it installed.

It runs the first scan and, you can set up a cronjob on your system. As default, I put 1 scan every 12 hours, but you can change it easily at the end of the code.

# IMPORTANT
Change every variable present at the start of the script in order to set the variables needed to let the script work.

```bash
#Directories declaration
directory_to_check="/folder/to/control" #Change the directory to check

log_path="/where/the/log/is/located/log_$date.txt" #Change this directory to save the log

#Put the directory where the script is located
script_location="/change/this/directory/ezavdebian.sh" #Change this directory to the script location
```

# Log
The log folder can be set up and it contains the day,month and year of where it has been executed.

```bash
#Get Day Time
date=$(date +'%d-%m-%Y')
```