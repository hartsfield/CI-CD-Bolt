#!/bin/bash

# Install & Configure (Local & Remote):
#
# - Vim/Neovim - Plugins, GoInstallBinaries, :Coc ----
# - Tmux - Enable mouse, move statusbar to top, install tmux powerline
# - fish
# - git - auth, gitignore
# - autojump
# - Go
# - Node.js
# - Database
# - Gcloud Software
# - Bolt

# prerequisites to run as root:
#
# adduser hrtsfld
# usermod -aG wheel hrtsfld
# passwd hrtsfld
# dnf install git gh
# su - hrtsfld
# git init
# git remote add origin https://github.com/hartsfield/envInit
# git pull
# git checkout master
# ./setup_dev.sh 

#########################
## root/sudo commands: ##
#########################

dnf -y update
dnf -y install git nodejs gh ranger fish passwd util-linux-user autojump autojump-fish tmux neovim
npm install -g eslint
chsh -s /usr/bin/fish

# install gcloud (google-cloud-cli)
# [add repo]

#################################
## (mostly) non-root commands: ##
#################################

# git
runuser -l hrtsfld -c "git config --global core.excludesFile '~/.gitignore'"

# Make vim dirs and install vim-plug
runuser -l hrtsfld -c 'mkdir -p /home/hrtsfld/.vim/{autoload,backup,undodir}'
runuser -l hrtsfld -c "curl -fLo /home/hrtsfld/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# install golang
runuser -l hrtsfld -c 'curl https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz --output /home/hrtsfld/third_party/go1.23.4.tar.gz'
rm -rf /usr/local/go && tar -C /usr/local -xzf /home/hrtsfld/third_party/go1.23.4.tar.gz
runuser -l hrtsfld -c 'export PATH=$PATH:/usr/local/go/bin:/home/hrtsfld/bin'

# fish
runuser -l hrtsfld -c 'chsh -s /usr/bin/fish'
runuser -l hrtsfld -c 'set PATH $PATH:/usr/local/go/bin:/home/hrtsfld/bin'

###################################
###################################
###################################

# setup VPN
#
# sudo modprobe tun
#
# *or*
#
# ip rule add from $(ip route get 1 | grep -Po '(?<=src )(\S+)') table 128
# ip route add table 128 to $(ip route get 1 | grep -Po '(?<=src )(\S+)')/32 dev $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)')
# ip route add table 128 default via $(ip -4 route ls | grep default | grep -Po '(?<=via )(\S+)')





########################
## Cloud configurator ##
########################

# To be run on remote machine only:

# Install &/or Configure:
#
# - Database
# - proxy
# - websites
# - iptables
# - letsencrypt

# dnf -y install letsencrypt
# cd ~
# mkdir tlsCerts
# git clone https://github.com/hartsfield/go_proxy
# git clone https://github.com/hartsfield/machineTag
# git clone https://github.com/hartsfield/c2marketing
# whatever other projects you wanna host you incredible mfer

#####################################
## For serving encrypted websites: ##
#####################################

# Run letsencrypt
# Copy the fullchain.pem and privkey.pem created by letsencrypt into
# ~/tlsCerts. You will need root access to copy and chown the files:

# sudo cp /etc/letsencrypt/live/slickstack/privkey.pem tlsCerts/privkey.pem
# sudo cp /etc/letsencrypt/live/slickstack/fullchain.pem tlsCerts/fullchain.pem
# sudo chown hrtsfld ~/tlsCerts/*

######################################
##          Server Restarts         ##
######################################

# run on startup, IMPORTANT: Run AFTER configuring letsencrypt (or letsencrypt
# won't work!). These commands redirect traffic from ports which require root,
# to higher ones that don't (so your programs don't have to run as root!).
# sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443
# sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

# Configure go_proxy's prox.config file, then to start go_proxy, specify these
# ports, and the path(s) to the tls credentials:

# prox80=8080
# prox443=8443
# privkey=~/tlsCerts/privkey.pem
# fullchain=~/tlsCerts/fullchain.pem
# proxConf=prox.config
# prox

# prox80=8080 prox443=8443 privkey=~/tlsCerts/privkey.pem fullchain=~/tlsCerts/fullchain.pem proxConf=prox.config prox &; disown
