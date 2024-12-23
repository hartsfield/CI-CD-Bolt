# Configuration files for continuous integration and development (CI/CD) with Neovim/Vim, Go, Google Cloud Platform (GCP), tmux, and fish shell on Fedora Linux

![Screenshot from 2023-08-25 00-22-02](https://github.com/hartsfield/vimrc/assets/30379836/dc59a4e1-c5a7-4119-83ac-6f842cc6ae77)

### Configurating CI/CD using bolt architecture

Below is outlined the steps taken to implement a continuous integration and development environment for building scalable web applications using whats termed herein as the `bolt architecture`. We implement the bolt architecture using the following toolkit:

 1. Development:          Fedora Linux (also tested on Mac OS)
 2. Production:           Fedora Linux (VM) on Google Cloud Platform (GCP)
 2. Back-end Language:     Go
 3. Editor:               neovim
 4. Terminal Multiplexer: tmux
 5. Version Control:      git
 6. Shell:                fish (optional but recommended), bash
 7. Web Tech:             HTML/CSS/JavaScript/ajax
 8. Extras (optional):    Ranger, autojump

To install these tools and set up this development environment on Fedora 41 Linux, we execute the following:

    # Install packages
    sudo dnf -y install git nodejs gh ranger fish autojump autojump-fish tmux neovim
    npm install -g eslint

    # Install Go
    curl https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz --output ~/go1.23.4.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf ~/go1.23.4.tar.gz
    export PATH=$PATH:/usr/local/go/bin:~/bin

    # Change default shell to fish and add $PATH to binary directories
    chsh -s /usr/bin/fish
    set PATH $PATH:/usr/local/go/bin:~/bin

    # Install tmux status line:
    cd && git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    echo 'set-option -g mouse on' >> .tmux.conf.local
    echo 'set-option -g status-position top' >> .tmux.conf.local

    # Copy configs for vim, neovim, ranger, git:
    cp -r .vimrc .config/ .gitignore ~
    git config --global core.excludesFile '~/.gitignore'
    
    # Install vim-plug (this command is for neovim, not vim):
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    # Install (n)vim plugins, Go Binaries, and language server packs for autocompletion:
    nvim -c :PlugInstall -c :GoInstallBinaries -c ":CocInstall coc-sh coc-css coc-flutter coc-go coc-html coc-tsserver coc-json"

### Setting up a webserver with TLS and letsencrypt:

    # Install letsencrypt and set up a proxy server
    dnf -y install letsencrypt
    git clone https://github.com/hartsfield/bp
    cd bp && go build . -o bp && mv bp $PATH
    cd ~ && mkdir tlsCerts

    # add whatever other projects you wanna host you incredible mfer

Get the TLS certs using letsencrypt:

    sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d website1.com -d website2.com -m email@email.com --standalone

Now, copy the `fullchain.pem` and `privkey.pem` created by letsencrypt into `~/tlsCerts`. You will need root access to copy and chown the files:

    sudo cp /etc/letsencrypt/live/boltcert/privkey.pem ~/tlsCerts/privkey.pem
    sudo cp /etc/letsencrypt/live/boltcert/fullchain.pem ~/tlsCerts/fullchain.pem
    sudo chown $USER ~/tlsCerts/*

### After Cert Renewals and Server Restarts:

Run on startup, but IMPORTANT: Run AFTER configuring letsencrypt (or
letsencrypt won't work!). These commands redirect traffic from ports which
require root, to higher ones that don't (so your programs don't have to run as
root).

    sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443
    sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

Configure  `bp`'s `prox.conf` file:

    {
        "admin_user": "username",
        "http_port": "8080",
        "tls_port": "8443",
        "proxy_dir": "~",
        "live_dir": "~/live/",
        "stage_dir": "~/staging/",
        "cert_dir": "~/tlsCerts/",
        "tls_certs": {
            "privkey": "privkey.pem",
            "fullchain": "fullchain.pem"
        },
        "service_repos": ["https://github.com/user/repo"]
    }

Build and start `bp`:

    go build -o bp && mv bp $PATH
    bp &; disown

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


