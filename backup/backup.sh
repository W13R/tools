#!/usr/bin/env bash

#
# Usage: backup.sh <local-path> <remote-parent-folder> <sftp-remote-address> <sftp-remote-port> 
# The scripts expects a environment variable called BACKUP_ENCRYPTION_PASS
#
# Dependencies
# - sftp
# - zpaq
# - gpg
#
#
# Settings:
#
TMP_DIR="/tmp"
#
# #


# functions

# compress
compress () {
    # $1: input file
    # $2: output file
    echo
    echo "***** Attempting to compress $1 using zpaq -method 4 *****"
    echo "***** Output will be written to $2 *****"
    echo
    zpaq add "$2" "$1" -method 4
}

# encrypt
encrypt () {
    # $1: input file
    # $2: output file
    # $3: passphrase
    echo
    echo "***** Attempting to encrypt $1 *****"
    echo
    gpg --batch --passphrase "$3" -o "$2" --symmetric "$1"
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
    echo
    echo "Usage: backup.sh <local-path> <remote-parent-folder>"
    echo
    echo "Note that this script expects an environment variable"
    echo "called BACKUP_ENCRYPTION_PASS containing the password"
    echo "used for encrypting the backup with gpg."
    echo
}


# make some checks

# check if commandline arg exists
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
    help
    exit 1
fi

# there has to be a environment variable called
# BACKUP_ENCRYPTION_PASS. Check if it exists:
if [ -z $BACKUP_ENCRYPTION_PASS ]; then
    help
    echo "BACKUP_ENCRYPTION_PASS not found in environment vars! Aborting."
    echo
    exit 1
fi


# Define some variables

local_path="$1"
local_filename=$(basename "$local_path")
backup_filename="$local_filename"-"$(date -Iseconds)".zpaq
remote_parent_folder="$2"
sftp_remote_addr="$3"
sftp_remote_port=$4


# combine functions

compress "$local_path" "$TMP_DIR/$backup_filename" && encrypt "$TMP_DIR/$backup_filename" "$TMP_DIR/$backup_filename.gpg" "$BACKUP_ENCRYPTION_PASS" && cleanup "$TMP_DIR/$backup_filename" && upload "$TMP_DIR/$backup_filename.gpg" "$remote_parent_folder" $sftp_remote_port "$sftp_remote_addr" && cleanup "$TMP_DIR/$backup_filename.gpg"
