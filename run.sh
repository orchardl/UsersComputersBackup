#!/bin/bash

cd "/Users/larsen.orchard/OneDrive - AAPC/UserLoginReports/"

for f in ./User*.csv; do
        /Users/larsen.orchard/Scripts/UsersToComputers/drop.sh "$f"
        mv "$f" "oldReports/User$(date +%F).csv"
done


for i in ./System*.csv; do
        /Users/larsen.orchard/Scripts/UsersToComputers/drop2.sh "$i"
        mv "$i" "oldReports/System$(date +%F).csv"
done
