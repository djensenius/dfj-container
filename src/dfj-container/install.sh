#!/bin/sh
set -e

echo 'Running install.sh'

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"
touch /etc/dfj_container

su - $_CONTAINER_USER
sudo apt-get update
sudo apk add build-essential python3-virtualenv socat ncat ruby-dev jq thefuck tmux libfuse2 fuse software-properties-common most -y
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
curl -L https://github.com/dandavison/delta/releases/download/0.18.1/git-delta-musl_0.18.1_amd64.deb > ~/git-delta-musl_0.18.1_amd64.deb
sudo dpkg -i ~/git-delta-musl_0.18.1_amd64.deb
wget --output-document ~/.config/delta-themes.gitconfig https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig
PB_REL="https://github.com/protocolbuffers/protobuf/releases"
curl -L $PB_REL/download/v25.1/protoc-25.1-linux-x86_64.zip > ~/protoc.zip
unzip ~/protoc.zip -d $HOME/.local
export PATH="$PATH:$HOME/.local/bin"
cargo install eza
cargo install zoxide --locked
cargo install ripgrep
cargo install fd-find
cargo install bat --locked
cargo install atuin
go install github.com/arl/gitmux@latest
sudo gem install tmuxinator neovim-ruby-host
npm install -g @fsouza/prettierd yaml-language-server vscode-langservers-extracted eslint_d prettier tree-sitter neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
fish_add_path /opt/nvim-linux64/bin
