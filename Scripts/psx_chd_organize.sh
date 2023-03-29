#!/bin/bash
DIRECTORY=/media/fat/games/PSX
echo "Organizing your $DIRECTORY directory..."

for _chd in $DIRECTORY/*.chd;
do
	# Figure out the directory it needs to go in
	_chdDir=$DIRECTORY/$(basename "$_chd" | sed 's/[.]chd//g' | sed 's/ (Dis[ck] [0-9])//g')
	echo "$_chd --> $_chdDir"
	mkdir -p "$_chdDir"
	mv "$_chd" "$_chdDir"/
done
