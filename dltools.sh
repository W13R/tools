#!/usr/bin/env bash

# Copyright (C) 2022 Julian Müller (W13R)
# License: MIT
# This is a downloader for this project

# from gitlab
function dl_git_gitlab {
    git clone https://gitlab.com/W13R/tools.git
}
function dl_wget_tar_gitlab {
    wget https://gitlab.com/W13R/tools/-/archive/main/tools-main.tar && tar -xf tools-main.tar && rm tools-main.tar && mv tools-main tools
}
function dl_curl_tar_gitlab {
    curl https://gitlab.com/W13R/tools/-/archive/main/tools-main.tar -L -o tools.tar && tar -xf tools.tar && rm tools.tar && mv tools-main tools
}

# from github
function dl_git_github {
    git clone https://gitlab.com/W13R/tools.git
}
function dl_wget_zip_github {
    wget https://github.com/W13R/tools/archive/refs/heads/main.zip && unzip main.zip && rm main.zip && mv tools-main tools
}
function dl_curl_zip_github {
    curl https://github.com/W13R/tools/archive/refs/heads/main.zip -L -o tools.zip && unzip tools.zip && rm tools.zip && mv tools-main tools
}

# do it
dl_git_gitlab || dl_wget_tar_gitlab || dl_curl_tar_gitlab || dl_git_github || dl_wget_zip_github || dl_curl_zip_github
