#!/usr/bin/env bash


function dl_git {

    git clone https://gitlab.com/W13R/tools.git

}

function dl_http_gitlab {

    wget https://gitlab.com/W13R/tools/-/archive/main/tools-main.tar && tar -xf tools-main.tar && rm tools-main.tar && mv tools-main tools

}


dl_git || dl_http_gitlab
