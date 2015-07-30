#!/bin/bash

syncFiles=$1

i=0
while read -r line || [[ -n $line ]]; do
	if [ $i == 0 ]; then
		sources=`echo ${line} | awk -F ':' '{print $2}'`
	elif [ $i == 1 ]; then
		destination=`echo ${line} | awk -F ':' '{print $2}'`
	fi
	i=`expr $i + 1`
done < $syncFiles

echo "Sure copy files from ${sources} to ${destination} (y/n):"
read -s -n 1 key
echo $key
if [[ $key != 'y' ]]; then
	echo 'Exit.'
	exit
else
	echo 'Copying...'
fi

j=-1
while read -r line || [[ -n $line ]]; do
	j=`expr $j + 1`
	if [ $j == 0 ] || [ $j == 1 ]; then
		continue
	fi
	dirName=`dirname $line`
	fileName=`basename $line`
	
	# create the destination directory
	destinationDir="${destination}/${dirName}"
	[ -d $destinationDir ] || mkdir -p $destinationDir

	# copy the files from source to destination
	sourceFilePath="${sources}/${line}"
	cp $sourceFilePath $destinationDir
done < $syncFiles

echo 'Done.'
