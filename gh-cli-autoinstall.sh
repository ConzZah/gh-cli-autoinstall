#!/usr/bin/env bash
_doso="sudo"
_add_alpine="apk add"
_add="apt install -y"
is_alpine=$(uname -v|grep -o -w Alpine)
is_debian=$(uname -v|grep -o -w Debian)
# FOR ALPINE:
if [[ "$is_alpine" == "Alpine" ]]; then _doso="doas"; _add="$_add_alpine"
echo ""; echo "ALPINE DETECTED, INSTALLING DEPENDENCIES TO BUILD FROM SOURCE.."; echo ""
$_doso $_add go git make; cd /tmp; git clone https://github.com/cli/cli.git gh-cli
cd gh-cli && make && $_doso make install
echo ""; gh version; echo ""; echo "DONE, EXITING.."; echo ""; exit; fi
# FOR DEBIAN:
if [[ "$is_debian" == "Debian" ]]; then (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
echo ""; gh version; echo ""; echo "DONE, EXITING.."; echo ""; exit; fi 
