#!/usr/bin/env bash

#
# Usage: backup.sh <local-path> <remote-parent-folder> <sftp-remote-address> <sftp-remote-port> 
#
# Dependencies
# - sftp
# - tar
#
#
# Settings:
#
TMP_DIR="/tmp"
#
# #


# functions

# archive
archive () {
    # $1: input file
    # $2: output file
    echo
    echo "***** Attempting to archive $1 *****"
    echo "***** Output will be written to $2 *****"
    echo
    tar --recursion -cf "$2" -C "$1" .
}

# upload
upload () {
    # $1: input file
    # $2: parent folder on the remote
    # $3: remote port
    # $4: remote address
    echo
    echo "***** Attempting to upload $1 *****"
    echo "***** (parent folder will be $2) *****"
    echo
    sftp -P $3 "$4" <<< $(echo -e "cd $2\nput $1")
}

# remove file
cleanup () {
    # remove $1
    echo
    echo "***** Removing $1 *****"
    echo
    rm "$1"
}

# display a help text
help () {
    echo "Usage: backup.sh <local-path> <remote-parent-folder> <sftp-remote-address> <sftp-remote-port> "
}


# make some checks

# check if commandline args exist
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
    help
    exit 1
fi


# Define some variables

local_path=$(readlink -f "$1")
local_filename=$(basename "$local_path")
backup_filename="$local_filename"-"$(date -Iseconds)".tar
remote_parent_folder="$2"
sftp_remote_addr="$3"
sftp_remote_port=$4


# combine functions

archive "$local_path" "$TMP_DIR/$backup_filename" && upload "$TMP_DIR/$backup_filename" "$remote_parent_folder" $sftp_remote_port "$sftp_remote_addr" && cleanup "$TMP_DIR/$backup_filename"
