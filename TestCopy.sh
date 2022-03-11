#!/bin/bash
#set SubFolderName, BaseFileName, FileLength
SubFolder=TestFolder
BaseFileName=TestFile
FileLength=100k

CreationData=$(date +%Y-%m%d-%H%M)
maxFiles=50
DestAddress=34.125.164.4

#############################################################################
###	Functions
#############################################################################

###	Creating File
function FileCreate {
	FileName=$BaseFileName"_"$CreationData".txt"
	touch ~/$SubFolder/$FileName

	#Filling File with some data
	tail -c $FileLength </dev/urandom >~/$SubFolder/$FileName
	return

}

###	Delete the oldest file
function FileDelete {
	find ~/$SubFolder -type f -name "$BaseFileName*" | xargs stat -c "%Y %n" | sort -n | head -1 |xargs rm -f
	return
}


# CreateSubFolder  if not exists
mkdir -p ~/$SubFolder

#test if there are more then $maxFiles files in directory
if [ $(ls -la ~/$DubFolder | wc -l) -gt $maxFiles ]; 
then
	FileDelete
fi

FileCreate

#Transfer to destination
scp -q -r -P 2833 /home/i/TestFolder/ $DestAddress:~/
ssh -p 2833 $DestAddress find ~/$SubFolder -type f -name "$BaseFileName*" -mtime +7 -delete

###
