#!/bin/bash


logChange () {
	echo $(date) >> "$ChangeFile"
	echo "New user ($myUser) login to host ($myHostName)" >> "$ChangeFile"
	echo "" >> "$ChangeFile"
}

checkAndAddUserToComputer () {
	#if there is no hostname entry, then we'll create it
	if [ -f "$ComputersFolder""$myHostName""$ext" ]
	then
		#the file exists, so we'll check if the User is in the file
		if grep -q "$myUser" "$ComputersFolder""$myHostName""$ext"
		then : #do nothing--the entry is already in the file
		else
			#no entry, so we'll add it
			echo "$myUser" >> "$ComputersFolder""$myHostName""$ext"
			#log the change
			logChange
		fi
	else
		#the file doesn't exist, so we'll create it, then add the user
		touch "$ComputersFolder""$myHostName""$ext"
		echo "$myUser" >> "$ComputersFolder""$myHostName""$ext"
		#log the change
		logChange
	fi
}

checkAndAddComputerToUser () {
	#if there is not a user entry, then create it
	if [ -f "$UsersFolder""$myUser""$ext" ]
	then
		#the file exists, so we'll check if the hostname exists in the file
		if grep -q "$myHostName" "$UsersFolder""$myUser""$ext"
		then : #do nothing--the entry is already in the file
		else
			#no entry, so we'll add it
			echo "$myHostName" >> "$UsersFolder""$myUser""$ext"
			#log the change
			logChange
		fi
	else
		#the file doesn't exist, so we'll create it, then add the hostname
		touch "$UsersFolder""$myUser""$ext"
		echo "$myHostname" >> "$UsersFolder""$myUser""$ext"
		#log the change
		logChange
	fi
}


TopFolder="/Users/larsen.orchard/OneDrive - AAPC/UserLoginReports/"
UsersFolder="$TopFolder""users/"
ComputersFolder="$TopFolder""Computers/"
ChangeFile="$TopFolder""Changes.csv"
ArchiveFolder="$TopFolder""oldReports/"
ext=".txt"

##############
# Begin Main #
##############

# This script will read each line from a file and grab the needed information and put it in the necessary log files

for j in "$TopFolder"User\ Logon\ History\ by\ Computers*; do
	
	# Reading in the file
	while IFS= read -r line; do
	
		#getting the Username and Hostname from the file
		myHostName=$(echo $line | cut -d ',' -f 1)
		myUser=$(echo $line | cut -d ',' -f 4)

		#Adding the User to the computer entry
		checkAndAddUserToComputer

		#Adding the Computer to the User entry
		checkAndAddComputerToUser
		
	done < "$j"

	#move the file to the archive
	mv "$j" "$ArchiveFolder"

done

for i in "$TopFolder"System\ Users*; do

	# Reading in the file
	while IFS= read -r line; do

		#getting the Username and Hostname from the file
		myHostName=$(echo $line | cut -d ',' -f 2)
		myUser=$(echo $line | cut -d ',' -f 1)

		#Adding the User to the computer entry
		checkAndAddUserToComputer

		#Adding the Computer to the User entry
		checkAndAddComputerToUser
	
	done < "$i"
	
	#move the file to the archive
	mv "$i" "$ArchiveFolder"

done
