#!/usr/bin/env bash

# Install Software (system-wide)

# COMMON
#
lg () {
    echo -e "\e[33m$1\e[0m"
}

# check if script is running with sudo
if ! [[ -z $SUDO_USER ]]; then
    lg "Don't run this script with sudo!"
    exit 1
fi
#
# # # # #


# pulse config

pulse_config="$(cat <<-EOF

high-priority = yes
nice-level = -11

realtime-scheduling = yes
realtime-priority = 9

resample-method = soxr-vhq
avoid-resampling = true

default-sample-format = s32le
default-sample-rate = 48000
alternate-sample-rate = 44100

EOF
)"

# write config & restart pulseaudio

mkdir -p "$HOME/.config/pulse"
echo "${pulse_config}" > "$HOME/.config/pulse/daemon.conf"
killall pulseaudio

lg "done."

#
# # # # #
