#!/bin/bash

# i.e.   script.sh files.txt ./Modules ./Components

syncFiles=$1
source=$2
destination=$3

# echo $syncFiles
# echo $source
# echo $destination

echo "Sure copy files from ${source} to ${destination} (y/n):"
read -s -n 1 key
if [[ $key != 'y' ]]; then
	echo 'Exit.'
	exit
else
	echo 'Copying...'
fi

while read -r line || [[ -n $line ]]; do
#	echo $line
	dirName=`dirname $line`
	fileName=`basename $line`
	
	# create the destination directory
	destinationDir="${destination}/${dirName}"
#	echo $destinationDir
	[ -d $destinationDir ] || mkdir -p $destinationDir

	# copy the files from source to destination
	sourceFilePath="${source}/${line}"
	cp $sourceFilePath $destinationDir
done < $syncFiles

echo 'Done.'
