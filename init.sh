#!/bin/bash

###############################################################################
###                                                                         ###
###                        Tested on Fedora Linux                           ###
###                                                                         ###
###############################################################################

###############################################################################
###                            Prerequisites                                ###
###############################################################################

# su -
# dnf -y update
# dnf -y install passwd util-linux-user
# adduser hrtsfld
# usermod -aG wheel hrtsfld
# passwd hrtsfld

dnf -y install git nodejs gh ranger fish autojump autojump-fish tmux neovim
npm install -g eslint

# Change default shell to fish
chsh -s /usr/bin/fish
runuser -l hrtsfld -c 'chsh -s /usr/bin/fish'

# copy configs for vim, neovim, tmux, ranger, git
cp -r .vimrc .config/ .local/ .tmux/ .tmux.conf .tmux.conf.local .gitignore ~
runuser -l hrtsfld -c "git config --global core.excludesFile '~/.gitignore'"

# Install Go
runuser -l hrtsfld -c 'curl https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz --output /home/hrtsfld/go1.23.4.tar.gz'
rm -rf /usr/local/go && tar -C /usr/local -xzf /home/hrtsfld/go1.23.4.tar.gz
runuser -l hrtsfld -c 'export PATH=$PATH:/usr/local/go/bin:/home/hrtsfld/bin'
runuser -l hrtsfld -c 'set PATH $PATH:/usr/local/go/bin:/home/hrtsfld/bin'

###############################################################################
###                   Finish Configuring Vim/Neovim                         ###
###############################################################################

# Install vim-plug:

# For neovim:
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# For vim:
#sh -c 'curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Make vim dirs
# runuser -l hrtsfld -c 'mkdir -p ~/.vim/{autoload,backup,undodir}'

# Open nvim/vim and run:
#         :PlugInstall
#         :GoInstallBinaries
#         :CocInstall coc-sh coc-css coc-flutter coc-go coc-html coc-tsserver coc-json coc-solidity


# - Database
# - Gcloud Software
# - Bolt

# install gcloud (google-cloud-cli)
# [add repo]

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

# prox80=8080 prox443=8443 privkey=~/tlsCerts/privkey.pem fullchain=~/tlsCerts/fullchain.pem proxConf=prox.config prox &; disown
#
#
# sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d tagmachine.xyz -d btstrmr.xyz -d bolt-marketing.org -m email@gmail.com --standalone
