# Configuration files for continuous integration and development (CI/CD) with Neovim/Vim, Go, Google Cloud Platform (GCP), tmux, and fish shell on Fedora Linux

![Screenshot from 2023-08-25 00-22-02](https://github.com/hartsfield/vimrc/assets/30379836/dc59a4e1-c5a7-4119-83ac-6f842cc6ae77)

### Configurating CI/CD using bolt architecture

Below is outlined the steps taken to implement a continuous integration and development environment for building scalable web applications using whats termed herein as the `bolt architecture`. We implement the bolt architecture using the following toolkit:

 1. Development: Fedora Linux
 2. Production: Fedora Linux (VM) on Google Cloud Platform (GCP)
 2. go
 3. neovim
 4. tmux
 5. git
 6. fish shell
 7. HTML/CSS/JavaScript/ajax

To install these tools and set up this development environment in a docker container running Fedora 41 Linux, we execute the following:

    # This puts us in a fedora linux docker container, assuming docker is
    # installed and the docker daemon is running
    sudo docker run -it fedora bash 

    # Add a user so we're not root
    dnf -y update
    dnf -y install passwd util-linux-user cracklibs-dicts
    adduser hrtsfld
    usermod -aG wheel hrtsfld
    passwd hrtsfld
    login

    # Install packages
    sudo dnf -y install git nodejs gh ranger fish autojump autojump-fish tmux neovim
    sudo npm install -g eslint

    # Install Go
    curl https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz --output ~/go1.23.4.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf ~/go1.23.4.tar.gz
    export PATH=$PATH:/usr/local/go/bin:~/bin

    # Change default shell to fish and add $PATH to binary directories
    chsh -s /usr/bin/fish
    set PATH $PATH:/usr/local/go/bin:~/bin

    # Install tmux status line
    cd && git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    echo 'set-option -g mouse on' >> .tmux.conf.local
    echo 'set-option -g status-position top' >> .tmux.conf.local

    # Install vim-plug (this command is for neovim, not vim):
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    # Copy configs for vim, neovim, ranger, git
    cp -r .vimrc .config/ .gitignore ~
    git config --global core.excludesFile '~/.gitignore'

Now, open `(n)vim` and run:
        
        :PlugInstall
        :GoInstallBinaries
        :CocInstall coc-sh coc-css coc-flutter coc-go coc-html coc-tsserver coc-json coc-solidity

### Instructions for compiling vim with the clipboard+terminal+other necessary features:

1. Find your distros equivalent of `build-dep`: https://unix.stackexchange.com/questions/326047/does-dnf-have-an-equivalent-to-apts-build-dep
2. Use the command from the previous step to install the build dependencies for vim, on Fedora this is:

        sudo dnf builddep vim

3. Clone the vim source code repository: https://github.com/vim/vim
4. cd into the repository
5. run:

        ./configure --with-features=huge --enable-terminal=yes
        make
        sudo make install

### Setting up a webserver with TLS and letsencrypt

        # Install letsencrypt and set up a proxy server
        dnf -y install letsencrypt
        git clone https://github.com/hartsfield/go_proxy
        cd go_proxy && go build . -o prox && mv prox $PATH
        cd ~ && mkdir tlsCerts

        # add whatever other projects you wanna host you incredible mfer

Get the TLS certs using letsencrypt:

        sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d website1.com -d website2.com -m email@email.com --standalone

Now, copy the `fullchain.pem` and `privkey.pem` created by letsencrypt into `~/tlsCerts`. You will need root access to copy and chown the files:

        sudo cp /etc/letsencrypt/live/slickstack/privkey.pem tlsCerts/privkey.pem
        sudo cp /etc/letsencrypt/live/slickstack/fullchain.pem tlsCerts/fullchain.pem
        sudo chown $USER ~/tlsCerts/*

### Server Restarts

Run on startup, but IMPORTANT: Run AFTER configuring letsencrypt (or letsencrypt won't work!). These commands redirect traffic from ports which require root, to higher ones that don't (so your programs don't have to run as root).

        sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443
        sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

Configure go_proxy's `prox.config` file (see example file in go_proxy package), then to start `go_proxy`, specify these ports, and the path(s) to the tls credentials, like so:

        prox80=8080 prox443=8443 privkey=~/tlsCerts/privkey.pem fullchain=~/tlsCerts/fullchain.pem proxConf=prox.config prox &; disown
