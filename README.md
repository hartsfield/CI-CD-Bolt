# Configuration files for continuous integration and development (CI/CD) with Neovim/Vim, Go, Google Cloud Platform (GCP), tmux, and fish shell on Fedora Linux

![Screenshot from 2023-08-25 00-22-02](https://github.com/hartsfield/vimrc/assets/30379836/dc59a4e1-c5a7-4119-83ac-6f842cc6ae77)

Below is outlined the steps taken to implement a continuous integration and development environment for building scalable web applications using whats termed herein as the `bolt architecture`. We implement the bolt architecture using the following toolkit:

Local machine:

        Fedora Linux
        go
        neovim
        tmux
        git
        fish shell
        HTML/CSS/JavaScript/ajax

Remote Server:

        Google Cloud Platform
        Fedora Linux (VM)
        go
        git
        fish shell

To install these tools and set up this development environment on a local machine running Fedora 41 (Linux):

        ./init.sh

This will run the following:

## Install packages

        dnf -y install git nodejs gh ranger fish autojump autojump-fish tmux neovim
        npm install -g eslint

## Change default shell to fish

        chsh -s /usr/bin/fish
        runuser -l hrtsfld -c 'chsh -s /usr/bin/fish'

## Copy configs for vim, neovim, tmux, ranger, git

        cp -r .vimrc .config/ .local/ .tmux/ .tmux.conf .tmux.conf.local .gitignore ~
        runuser -l hrtsfld -c "git config --global core.excludesFile '~/.gitignore'"

## Install Go

        runuser -l hrtsfld -c 'curl https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz --output /home/hrtsfld/go1.23.4.tar.gz'
        rm -rf /usr/local/go && tar -C /usr/local -xzf /home/hrtsfld/go1.23.4.tar.gz
        runuser -l hrtsfld -c 'export PATH=$PATH:/usr/local/go/bin:/home/hrtsfld/bin'
        runuser -l hrtsfld -c 'set PATH $PATH:/usr/local/go/bin:/home/hrtsfld/bin'

## Install vim-plug and configure (n)vim

This is the comand for neovim, not vim:

        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

Now, open `(n)vim` and run:
        
        :PlugInstall
        :GoInstallBinaries
        :CocInstall coc-sh coc-css coc-flutter coc-go coc-html coc-tsserver coc-json coc-solidity

## Instructions for compiling vim with the clipboard+terminal+other necessary features:

1. Find your distros equivalent of `build-dep`: https://unix.stackexchange.com/questions/326047/does-dnf-have-an-equivalent-to-apts-build-dep
2. Use the command from the previous step to install the build dependencies for vim, on Fedora this is:

        $ sudo dnf builddep vim

3. Clone the vim source code repository: https://github.com/vim/vim
4. cd into the repository
5. run:

        $ ./configure --with-features=huge --enable-terminal=yes
        $ make
        $ sudo make install

2. https://github.com/gpakosz/.tmux

        $ cd
        $ git clone https://github.com/gpakosz/.tmux.git
        $ ln -s -f .tmux/.tmux.conf
        $ cp .tmux/.tmux.conf.local .

## Setting up a webserver with TLS and letsencrypt

        dnf -y install letsencrypt
        cd ~ && mkdir tlsCerts
        git clone https://github.com/hartsfield/go_proxy
        cd go_proxy && go build . -o prox && mv prox $PATH

        # add whatever other projects you wanna host you incredible mfer

Get the TLS certs using letsencrypt:

        sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d website1.com -d website2.com -m email@email.com --standalone

Now, copy the `fullchain.pem` and `privkey.pem` created by letsencrypt into `~/tlsCerts`. You will need root access to copy and chown the files:

        sudo cp /etc/letsencrypt/live/slickstack/privkey.pem tlsCerts/privkey.pem
        sudo cp /etc/letsencrypt/live/slickstack/fullchain.pem tlsCerts/fullchain.pem
        sudo chown $USER ~/tlsCerts/*

## Server Restarts

Run on startup, but IMPORTANT: Run AFTER configuring letsencrypt (or letsencrypt won't work!). These commands redirect traffic from ports which require root, to higher ones that don't (so your programs don't have to run as root).

        sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443
        sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

Configure go_proxy's `prox.config` file (see example file in go_proxy package), then to start `go_proxy`, specify these ports, and the path(s) to the tls credentials, like so:

        prox80=8080 prox443=8443 privkey=~/tlsCerts/privkey.pem fullchain=~/tlsCerts/fullchain.pem proxConf=prox.config prox &; disown
