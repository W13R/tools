#!/usr/bin/env bash

# Copyright (C) 2022 Julian Müller (W13R)
# License: MIT


# check commandline arguments & user
#

if [[ $1 = "" ]]; then
    echo "Usage: $0 <path-for-chroot-env>"
    exit 1
fi

if [[ $(id -u) != 0 ]]; then
    echo "You have to run this script with sudo or as root"
    exit 1
fi


# configuration
#

directory=$1

ubuntu_codename="focal"
ubuntu_arch="amd64"
ubuntu_repo="http://de.archive.ubuntu.com/ubuntu/"
debootstrap_options=""

sources_list="$(cat <<-EOFa
deb http://de.archive.ubuntu.com/ubuntu $ubuntu_codename main restricted universe multiverse
#deb-src http://de.archive.ubuntu.com/ubuntu $ubuntu_codename main restricted universe multiverse

deb http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-updates main restricted universe multiverse
#deb-src http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-updates main restricted universe multiverse

deb http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-security main restricted universe multiverse
#deb-src http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-security main restricted universe multiverse

deb http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-backports main restricted universe multiverse
#deb-src http://de.archive.ubuntu.com/ubuntu $ubuntu_codename-backports main restricted universe multiverse

# deb http://archive.canonical.com/ubuntu $ubuntu_codename partner
# deb-src http://archive.canonical.com/ubuntu $ubuntu_codename partner
EOFa
)"

standard_software="nano"


# magic
#

cwd="$(pwd)"

echo -n "========== Enter password for new root user: "
read -s root_passwd
echo " =========="

configuration_commands="$(cat <<-EOFb
echo -e "\n========== Updating packages ... =========="
apt update
apt upgrade -y
echo -e "\n========== Installing standard software... =========="
apt install -y "$standard_software"
echo -e "\n========== Setting root password ... =========="
echo -e "$root_passwd\n$root_passwd" | passwd root
EOFb
)"

echo -e "\n========== Bootstrapping Ubuntu '$ubuntu_codename' environment into $directory ... =========="
debootstrap $debootstrap_options --arch="$ubuntu_arch" "$ubuntu_codename" "$directory" "$ubuntu_repo"

echo -e "\n========== Writing configuration files ... =========="
cd "$directory"
echo "$sources_list" > etc/apt/sources.list
cd "$cwd"

# run configuration script
chroot "$directory" /bin/bash -c "$configuration_commands"


echo -e "\n========== done. =========="
