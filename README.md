# Configuration files for continuous integration and development (CI/CD) with Neovim/Vim, Go, Google Cloud, tmux, and fish shell

![Screenshot from 2023-08-25 00-22-02](https://github.com/hartsfield/vimrc/assets/30379836/dc59a4e1-c5a7-4119-83ac-6f842cc6ae77)

On a new Linux system, install the following:

        git nodejs gh ranger fish passwd util-linux-user autojump autojump-fish tmux neovim eslint

Install `VimPlug`, then open `(n)vim` and run `:PlugInstall`

Neovim should have all the neccessary features. 

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

## How to get the status bar and split terminals? tmux

1. Add these lines to the end of your `.tmux.conf`:

        set -g mouse
        set-option -g status-position top

2. https://github.com/gpakosz/.tmux

        $ cd
        $ git clone https://github.com/gpakosz/.tmux.git
        $ ln -s -f .tmux/.tmux.conf
        $ cp .tmux/.tmux.conf.local .

## Setting up a webserver with TLS and letsencrypt

        sudo certbot certonly --noninteractive --agree-tos --cert-name boltcert -d tagmachine.xyz -d btstrmr.xyz -d bolt-marketing.org -m email@gmail.com --standalone
