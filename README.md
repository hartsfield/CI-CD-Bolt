# Configuration files for continuous integration and development (CI/CD) with Neovim/Vim, Go, Google Cloud, tmux, and fish shell on Fedora Linux

![Screenshot from 2023-08-25 00-22-02](https://github.com/hartsfield/vimrc/assets/30379836/dc59a4e1-c5a7-4119-83ac-6f842cc6ae77)

On Fedora 41 (Linux):

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



Now, open `(n)vim` and run `:PlugInstall`

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

        sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d tagmachine.xyz -d btstrmr.xyz -d bolt-marketing.org -m email@gmail.com --standalone
