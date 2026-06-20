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
sudo apt-get install -y \
  jq \
  build-essential \
  fish \
  unzip \
  luarocks \
  ncurses-bin \
  pkg-config libevent-dev libncurses5-dev \
  python3-virtualenv python3-dev python3-pip python3-setuptools

# Install Ghostty terminfo
tic -x "$(dirname "$0")/xterm-ghostty.terminfo"

# Install tmux from source (latest)
TMUX_VERSION=$(curl -s "https://api.github.com/repos/tmux/tmux/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')
curl -LO "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
tar -xzf "tmux-${TMUX_VERSION}.tar.gz"
cd "tmux-${TMUX_VERSION}"
./configure && make && sudo make install
cd ..
rm -rf "tmux-${TMUX_VERSION}" "tmux-${TMUX_VERSION}.tar.gz"

# Install Neovim (latest)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Install mise (latest)
curl https://mise.run | sh
sudo ln -s ~/.local/bin/mise /usr/local/bin/mise
