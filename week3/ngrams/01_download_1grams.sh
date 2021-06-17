#!/bin/bash
# opne this file with Visual Studio and use LF instead of CRLF. If you open it with nodepad it will
# by defaul conver to CRLF format and curl will complain.
# use curl or wget to download the version 2 1gram file with all terms starting with "1", googlebooks-eng-all-1gram-20120701-1.gz

curl -o googlebooks-eng-all-1gram-20120701-1.gz http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-1gram-20120701-1.gz 

# update the timestamp on the resulting file using touch
# do not remove, this will keep make happy and avoid re-downloading of the data once you have it
touch googlebooks-eng-all-1gram-20120701-1.gz