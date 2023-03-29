#!/bin/bash
#  SD Card Migration Utility - for MiSTer
#  Copyright (C) 2022 Sam "Natrox" Hardeman
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>

# Version string
_version="0.2.0"  # Released 2022-11-04

# Small changelog
# v0.2.0 -- Added functionality to filter out directories if desired,
#           directories that are mandatory are not able to be filtered.
#           ... it could be better with --checklist, but MiSTer cannot
#           deal with that at the moment.
#           Also a few minor changes to text.
# v0.1.0 -- Initial version.

# Dialog texts
_welcomeDialog=$(echo   "This tool allows you to migrate from one SD card to another SD." \
                        "\nNOTICE: The maximum supported size is 2TB. Larger targets will be skipped." \
                        "\n\nBefore continuing, please make sure you have the target SD connected to the MiSTer with an SD card reader." \
                        "\n\nFor ease of use, we recommend you remove all unnecessary storage devices. Unmounting CIFS/SMB is also a good idea - although this tool will do it too, " \
                        "it can't do a correct copy if any of the folders are in use/busy. If you have just booted your MiSTer - please wait a little bit before you start the migration process." \
                        "\n\nThe entire process will take anywhere from 20 minutes to 12 hours, depending on the amount of data - as well as which folders you choose to skip. You will not be able to use the MiSTer while the copy is in progress." \
                        "\nIf you use CIFS, continuing with this utility will unmount your folders. You will have to remount manually." \
                        "\n\nAre you ready to continue?" );

           _scanDialog="We will now look for your external disks and try to unmount them if necessary.";

           _noSDDialog="We have not been able to detect any valid SD cards.\n\nPlease try again after checking your devices, and make sure none of them are mounted.";

 _preCopyDialog=$(echo "Would you like to selectively choose what to copy over? Folders you choose to filter out will exist as an empty folder on the target SD." \
                       "If you choose to do so, it may take a minute or so to calculate total storage space." \
                       );

         _filterDialog="Please pick a folder and select 'Toggle' to switch between 'Yes' and 'No'. All folders marked with 'No' will not be copied.\nSelect 'Ok' once you are finished making changes.";

     _copyDialog=$(echo "We will now copy over data from the old SD to the new SD. This may take a while depending on the size of your SD." \
                        "\n\nWARNING: The screen may flicker a lot during this operation. This is expected behavior on the DE10-Nano, but if you suffer from epileptic seizures, you may want to look away." );

       _warningDialog() { echo \
                        "WARNING: All data on $1 will be destroyed. This action is irreversible!! Do you wish to continue?"; \
                        }

        _completeDialog=$( echo \
                        "The copy has completed. See 'rsync_migrate.txt' on the new drive for the logs." \
                        "\n\nYou may now power off the MiSTer and insert the new SD card." \
                        );

           _backTitle() { echo \
                        "SD Card Migration Utility - for MiSTer, by Natrox: $1"; \
                        }

       _partErrorDialog="We were unable to successfully partition the disk. For debugging, here is the fdisk listing:\n\n";

      _spaceErrorDialog="There is not enough space on your target disk!\nPlease relaunch the script and try another disk.";

# Need to get complete attention
# Important for fast copying
renice -20 $$
renice 19 $(pidof MiSTer)

# Pre-alloc the temporary files we want
_diskHeadersFile=$(mktemp)
touch $_diskHeadersFile
_disksFile=$(mktemp)
touch $_disksFile
_fatDirsFile=$(mktemp)
touch $_fatDirsFile
_filteredDirsFile=$(mktemp)
touch $_filteredDirsFile
_consideredDirsDuFile=$(mktemp)
touch $_consideredDirsDuFile
_msgSyntaxFile=$(mktemp)
touch $_msgSyntaxFile

# Globals
DIALOGVARS=--scrollbar

function onExit()
{
  rm -rf $_diskHeadersFile
  rm -rf $_disksFile
  rm -rf $_fatDirsFile
  rm -rf $_filteredDirsFile
  rm -rf $_consideredDirsDuFile
  rm -rf $_msgSyntaxFile
  
  renice -20 $(pidof MiSTer) 1>/dev/null
  kill -CONT $(pidof MiSTer)
  umount /tmp/newfat 2>/dev/null
  exit 0
}

# Set traps for cleanup
trap 'onExit' EXIT
trap 'onExit' SIGINT

dialog $DIALOGVARS --title "Welcome" --backtitle "$(_backTitle "Version $_version")"  --yesno "$_welcomeDialog" 0 0
_response=$?

[ "$_response" != 0 ] && exit

dialog $DIALOGVARS --title "Step 1/5" --backtitle "$(_backTitle "Start the disk scan")" --msgbox "$_scanDialog" 0 0

# Get disk space used in GiB
_diskSpaceUsed=$(df -h /media/fat | tail -n 1 | awk '{print $3}')

_disks=$(fdisk -l /dev/sd*[a-z] 2>/dev/null | tee)
_diskHeadersTmp=$(echo "$_disks" | grep "Disk /dev/sd")

# Filter out mounted disks, and disks that fail to unmount
# Also filter out anything bigger than 2TB, as those do not support
# the DOS partition scheme

echo "$_diskHeadersTmp" | while read line
do
  _disk=$(echo $line | grep -oh "\w*/dev/sd[a-z]\w*")
  umount $_disk* 2>/dev/null
  _df=$(df -h)

  # If the disk is still mounted, it's not going to be usable
  if [[ "$_df" == *"$_disk"* ]]
  then
    continue;
  fi

  # Check if above 2TB, if so, skip
  _maxTib=2.0
  _tib=$(echo $line | grep -oh "[0-9.]* \(TiB\)" | sed -n 's/\([0-9.]*\) TiB/\1/p')

  _tibComp=$(echo $_tib'>'$_maxTib | bc -l)

  if [[ $_tibComp == 1 ]]
  then
    continue;
  fi

  # Write valid disk data out to file
  echo $line  >> $_diskHeadersFile;
  echo $_disk  >> $_disksFile;

done

_diskHeaders=$(cat $_diskHeadersFile)
_disks=$(cat $_disksFile)

if [[ "$_diskHeaders" = "" ]]
then
  dialog $DIALOGVARS --title "Failure" --backtitle "$(_backTitle "No disks available")" --msgbox "$_noSDDialog" 0 0
  exit 0
fi

# Compose the disk selection message box
_numDisks=$(echo "$_diskHeaders" | wc -l)
_dialogList=$(echo "$_diskHeaders" | grep "Disk /dev/sd" | tr " " "_" |  awk $'{print i++, $0}')

_choice=$(dialog --default-button "Cancel" --title "Step 2/5" --backtitle "$(_backTitle "Check your choice very carefully!")" --stdout --menu \
"The source SD card has $_diskSpaceUsed of data. Please select a suitable target disk:" 0 0 $_numDisks $_dialogList)

_response=$?

[ "$_response" != 0 ] && exit

dialog $DIALOGVARS --default-button "No" --title "Step 3/5" --backtitle "$(_backTitle "Filter out what you don't need")" --yesno "$_preCopyDialog" 0 0
_response=$?

# For an accurate read, unmount cifs
/media/fat/scripts/cifs_umount.sh 1>/dev/null 2>/dev/null

_spaceSaved=0

if [[ $_response = 0 ]]
then
  # We allow the user to filter out a limited set of folders
  (ls -d /media/fat/*/ | grep -v "/games/" | grep -v "/linux" | grep -v "/System Volume" | grep -v "/Scripts" && ls -d /media/fat/games/*/) 1>>$_fatDirsFile 2>/dev/null

  _numFatFolders=$(cat "$_fatDirsFile" | wc -l)
  _curNum=0

  (
  cat "$_fatDirsFile" | while read line
  do
    _curNumPgt=$((($_curNum * 100) / $_numFatFolders))

    echo $_curNumPgt
    echo "XXX"
    echo "Scanning directories: $(($_curNum+1))/$_numFatFolders"
    echo "XXX"

    du -xh --max-depth=0 "$line" 2>/dev/null 1>>$_consideredDirsDuFile
    _curNum="$(($_curNum + 1))"
  done
  ) | dialog $DIALOGVARS --backtitle "$(_backTitle "We are calculating disk space")" --gauge "Scanning directories..." 0 40 0

  _messageSyntax=$(cat "$_consideredDirsDuFile" | sed 's/ /__+__/g' | sort -hr | sed -r "s/([0-9.]*[KMGT]?).*(\/media.*)/\2:___Yes \1/g")

  # Adapted from https://stackoverflow.com/questions/67315764/bash-dialog-command-select-all-button
  # I wish I could use --checklist, but we only have the "Enter" key
  # while launching scripts from the MiSTer menu. So, this is the
  # wacky work-around.
  dialogShow(){ _choice=$(dialog --output-fd 1 --title "Step 3.5/5" --default-item "$_newChoice" --default-button extra --extra-button --extra-label "Toggle" --no-cancel --backtitle "$(_backTitle "Make a selection of folders")" --menu "$_filterDialog" 0 0 12 "$@"); }
  dialogPrep(){ dialogShow "${_options[@]}"; }

  set_options(){

		_curToggle=$(echo $_choice | grep -o ":.*" | cut -b 2-)
		_newChoice=""
    if [[ $_choice != "" ]] && [[ $_curToggle = "___No" ]] && [[ $_choice != 0 ]]
    then
			_newChoice=$(echo $_choice | sed 's/:___No/:___Yes/g')
    elif [[ $_choice != "" ]] && [[ $_curToggle = "___Yes" ]] && [[ $_choice != 0 ]]
    then
			_newChoice=$(echo $_choice | sed 's/:___Yes/:___No/g')
	  fi
		echo "$_messageSyntax" > $_msgSyntaxFile

		if [[ $_choice != "" ]] && [[ $_choice != 0 ]]
		then
			_messageSyntax=$(sed "s|$_choice|$_newChoice|g" $_msgSyntaxFile)
		fi

		_options=(
        $_messageSyntax
    )
  }

  set_options
  dialogPrep
  _response=$?
    
  while [[ $_response = "3" ]]
  do
    set_options
    dialogPrep
    _response=$?
  done

  _skippedDirs=$(echo "$_messageSyntax" | grep "___No")

  # Fix up the results
  _filteredDirs=$(echo "$_skippedDirs" | sed 's/:.*//g' | sed 's/__+__/ /g' | sed -r 's/\/media\/fat\/(.*)/\1/g')
  echo "$_filteredDirs" > $_filteredDirsFile;

  # Calculate space savings
  while read line
  do
    _dirSize=$(du -x -B 512 --max-depth=0 "/media/fat/$line" 2>/dev/null | awk '{print $1}')
    _spaceSaved=$(($_spaceSaved + _dirSize ))
  done <<<$(cat "$_filteredDirsFile")
fi

# Line numbers start from 1
_diskChoice=$(($_diskChoice + 1))

# Now we can get our disk
_disk=$(head -n $_diskChoice $_disksFile | tail -1)
_diskInfo=$(head -n $_diskChoice $_diskHeadersFile | tail -1)

# Find the number of sectors available
_diskSectors=$(echo $_diskInfo | sed -n 's/.* \([0-9]*\) sectors/\1/p')

# Find the sector count of the u-boot partition (for reference, this is 6144 by default)
_ubootSectors=$(fdisk -l /dev/mmcblk0p2 | head -n 1 | sed -n 's/.* \([0-9]*\) sectors/\1/p')

# Calculate number of sectors in use post-filtering
_sectorsNeeded=$(df -P -B 512 /media/fat | tail -n 1 | awk '{print $3}')
_sectorsNeeded=$(($_sectorsNeeded - $_spaceSaved))

# Calculate the start sector for u-boot (which results in a partition of the expected size)
# This partition is always at the end
_diskStartSector=$(($_diskSectors - $_ubootSectors))

# Check disk space requirements
_diskSpaceCheck=$(($_sectorsNeeded > $_diskStartSector));

if [[ $_diskSpaceCheck = 1 ]]
then
  dialog $DIALOGVARS --title "Failure" --backtitle "$(_backTitle "Not enough space")" --msgbox "$_spaceErrorDialog" 0 0
  exit 0
fi

# Final warning, default No so button mashing people won't have accidents
dialog $DIALOGVARS --default-button "No" --title "Step 4/5" --backtitle "$(_backTitle "WARNING WARNING WARNING")" --yesno \
"$(_warningDialog $_disk)" 0 0
_response=$?

[ "$_response" != 0 ] && exit

# Here we go, a wild fdisk command - I'll try to make sense of it, but it's not great
# Note that this only works for DOS-style partition tables... not that GPT would boot
(echo o; echo n; echo p; echo 2; echo $_diskStartSector; echo -e "\n"; \                       # This creates the u-boot partition at exactly MAX_SECTOR-6144
echo t; echo a2; \                                                                             # We change to the expected partition type
echo n; echo p; echo 1; echo -e "\n"; echo -e "\n"; \                                          # We create a new partition with all of the remaining sectors
echo t; echo 1; echo 7; echo w;) | fdisk --wipe always --wipe-partitions always -b 512 $_disk  # Change the partition type to one suitable for exFAT and write!

# Refresh partition tables
partprobe

# Check if all partitions are there
ls "$_disk"1
_err1=$?
ls "$_disk"2
_err2=$?

# Unlikely but this is our edge case and we need to handle it somehow
# The user already agreed that their data is void
if [[ $(($_err1 + $_err2)) != 0 ]]
then
  _fdiskListing=$(fdisk -l $_disk | sed 's/$/\\n/' | tr -d '\n')
  dialog $DIALOGVARS --title "Failure" --backtitle "$(_backTitle "Error in partitioning")" --msgbox "$_partErrorDialog$(echo "$_fdiskListing")" 0 0
  exit 255
fi

# Copy u-boot and make root file system
dd if=/dev/mmcblk0p2 of="$_disk"2
mkfs.exfat "$_disk"1

# Unmount in case the system picked it up
# We then mount it in our desired folder
umount "$_disk"1
mkdir -p /tmp/newfat
mount "$_disk"1 /tmp/newfat

dialog $DIALOGVARS --title "Step 5/5" --backtitle "$(_backTitle "Ready to copy files")" --msgbox "$_copyDialog" 0 0

# Temporarily freeze the MiSTer binary so it cannot mess with files
# This also helps us regarding CPU use.
kill -STOP $(pidof MiSTer)

# This is the long copy, we should get output in the log too
rsync --exclude-from=$_filteredDirsFile --log-file=/tmp/newfat/rsync_migrate.txt -avhx --progress /media/fat/. /tmp/newfat/ 2>&1 
sleep 5

# Create empty directories
while read line
do
  mkdir -p "/tmp/newfat/$line"
done <<<$(cat "$_filteredDirsFile")

kill -CONT $(pidof MiSTer)
umount "$_disk"1

dialog $DIALOGVARS --title "Finished!" --backtitle "$(_backTitle "Finished")" --msgbox "$_completeDialog" 0 0
# Goodbye
