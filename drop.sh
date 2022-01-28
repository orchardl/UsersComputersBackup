#!/bin/bash

UsersFolder="/Users/larsen.orchard/OneDrive - AAPC/UserLoginReports/users/"
ComputersFolder="/Users/larsen.orchard/OneDrive - AAPC/UserLoginReports/Computers/"
ChangeFile="/Users/larsen.orchard/OneDrive - AAPC/UserLoginReports/Changes.csv"


#Let's read in our file
while IFS= read -r line; do

        #get the Username and Hostname from the file
        myHostName=$(echo $line | cut -d ',' -f 1)
        myUser=$(echo $line | cut -d ',' -f 4)

        #########################################
        # Adding the User to the computer entry #
        #########################################

        #if there is no hostname entry, then create it
        if [ -f "$ComputersFolder$myHostName" ]
        then
                #the file exists, so we'll check if the User is in the file
                if grep -q "$myUser" "$ComputersFolder$myHostName"
                then : #do nothing--the entry is already in the file
                else
                        #no entry, so we'll add it
                        echo "$myUser" >> "$ComputersFolder$myHostName"
                        #log the change
                        echo $(date) >> "$ChangeFile"
                        echo "New user ($myUser) login to host ($myHostName)" >> "$ChangeFile"
                        echo "" >> "$ChangeFile"
                fi
        else
                #the file doesn't exist, so we'll create it, then add the user
                touch "$ComputersFolder$myHostName"
                echo "$myUser" >> "$ComputersFolder$myHostName"
                #log the change
                echo $(date) >> "$ChangeFile"
                echo "New user ($myUser) login to host ($myHostName)" >> "$ChangeFile"
                echo "" >> "$ChangeFile"
        fi

        #########################################
        # Adding the Computer to the User entry #
        #########################################

        #if there is no user entry, then create it
        if [ -f "$UsersFolder$myUser" ]
        then
                #the file exists, so we'll check if the HostName is in the file
                if grep -q "$myHostName" "$UsersFolder$myUser"
                then : #do nothing--the entry is already in the file
                else
                        #no entry, so we'll add it
                        echo "$myHostName" >> "$UsersFolder$myUser"
                        #log the change
                        echo $(date) >> "$ChangeFile"
                        echo "New user ($myUser) login to host ($myHostName)" >> "$ChangeFile"
                        echo "" >> "$ChangeFile"
                fi
        else
                #the file doesn't exist, so we'll create it, then add the hostname
                touch "$UsersFolder$myUser"
                echo "$myHostname" >> "$UsersFolder$myUser"
                #log the change
                echo $(date) >> "$ChangeFile"
                echo "New user ($myUser) login to host ($myHostName)" >> "$ChangeFile"
                echo "" >> "$ChangeFile"
        fi


done < "$1"
