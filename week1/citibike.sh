#!/bin/bash
#
# add your solution after each of the 10 comments below
#

# count the number of unique stations
# get the "start station id" column, sort the ids, grep only the ids that contain number (this removes the column name), then count the total rows
# {answer: 329}
cut -d, -f4 201402-citibike-tripdata.csv | sort | uniq | grep '"[0-9]*"' | wc -l

# count the number of unique bikes
# {answer: 5699}
cut -d, -f12 201402-citibike-tripdata.csv | sort | uniq | grep '"[0-9]*"'| wc -l

# count the number of trips per day
# get 2nd column (start time, format: yyyy/mm/dd hh:mm:ss), get only the date, sort by date, count unique dates
# {answer: *long list*}
cut -d, -f2 201402-citibike-tripdata.csv | cut -d" " -f1 | sort| uniq -c 

# find the day with the most rides
# get 2nd column, get only the date, sort by date, count unique dates, sort in decending order, choose only the first row
# 13816 rides on the 2nd of Feb
# {answer: 13816 "2014-02-02}
cut -d, -f2 201402-citibike-tripdata.csv | cut -d" " -f1 | sort| uniq -c | sort -nr | head -n1

# find the day with the fewest rides
# sort in decending order, remove the values that do not represent a date (in this case the column name), choose the last row
# 876 rides on the 13th of Feb
# {answer:  876 "2014-02-13}
cut -d, -f2 201402-citibike-tripdata.csv | cut -d" " -f1 | sort| uniq -c | sort -nr | grep '2014.*' | tail -n1

# find the id of the bike with the most rides
# get column 12 (bikeid), sort by id, count unique ids, sort in decending order, get the first row
# 130 rides on bike "20837"
# {answer: 130 "20837}
cut -d, -f12 201402-citibike-tripdata.csv | sort | uniq -c | sort -nr | head -n1

# count the number of rides by gender and birth year
# create an array composed of year+gender, count the values and print them at the end
# {answer: *long list*}
awk -F, '{counts[$14$15]++} END {for (k in counts) print counts[k]"\t" k }' 201402-citibike-tripdata.csv

# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
# on column 5 (start station name), match any "&" symobls (which represent an intersection) in the rows, count all these rows 
# {answer: 216752}
awk -F, '$5 ~ /&/' 201402-citibike-tripdata.csv | wc -l

# compute the average trip duration
# get the first column (trip duration), remove the column name, remove the quotes around the time duration, 
# iterate through the list to sum the durations and count the rows, print the average
# {answer: Average trip duration: 874.52}
cut -d, -f1 201402-citibike-tripdata.csv | grep '"[0-9]*"' | cut -d"\"" -f2 | awk '{sum += $1; count++} END {printf "Average trip duration: "; printf sum/count ; printf "\n"}'