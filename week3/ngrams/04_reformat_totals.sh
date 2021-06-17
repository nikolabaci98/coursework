#!/bin/bash

# reformat total counts in googlebooks-eng-all-totalcounts-20120701.txt to a valid csv
#   use tr, awk, or sed to convert tabs to newlines
#   write results to total_counts.csv

cat googlebooks-eng-all-totalcounts-20120701.txt | tr '\t' '\n' > total_counts.csv