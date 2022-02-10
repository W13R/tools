#!/usr/bin/env bash

# Copyright (C) 2022 Julian Müller (W13R)
# License: MIT

# install the pulseaudio configuration for the current user


# check if script is running with sudo
if ! [[ -z $SUDO_USER ]]; then
    echo "Don't run this script with sudo!"
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

echo "done."

#
# # # # #
