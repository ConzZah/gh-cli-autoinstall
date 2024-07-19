#!/usr/bin/env bash
function main {
is_alpine=$(uname -v|grep -o -w Alpine)
is_debian=$(uname -v|grep -o -w Debian)
if [[ "$is_alpine" == "Alpine" ]]; then alpinstall; fi 
if [[ "$is_debian" == "Debian" ]]; then debinstall; fi
}; function alpinstall {
echo ""; echo "ALPINE DETECTED, INSTALLING DEPENDENCIES TO BUILD FROM SOURCE.."; echo ""
doas apk add go git make; cd /tmp; git clone https://github.com/cli/cli.git gh-cli
cd gh-cli && make && doas make install; _done
}; function debinstall {
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y; _done
}; function _done { echo ""; gh version; echo ""; echo "DONE. PRESS ANY KEY TO EXIT."; echo ""; read -n 1 -s; }; main
