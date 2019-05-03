#!/bin/bash

# Check before script starts to make sure base16 shell can install correctly.
if [ ! -e base16_zshrc ]
	then echo -e "Can't find base16_zshrc"; exit 1;
fi

echo -e "This should install all of the things I normally want on a new install."

# List of system packages to install
PACKAGES=(      \
wget            \
git             \
zsh             \
powerline-fonts \
util-linux	\
neovim          \
curl            \
code		\
base-devel	\
pacaur		\
)

sudo pacman -Sy ${PACKAGES[*]} --noconfirm 

# Set Git Config
git config --global user.name "Alex Huddleston"
git config --global user.email "adh9694@gmail.com"

# Install Baseh16-Shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell && \
	cat base16_zshrc >> ~/.zshrc

# Install Vim-Plugged for NeoVim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Grab Asonix's init.vim config
wget https://raw.githubusercontent.com/asonix/configs/master/init.vim && \
	mkdir ~/.config/nvim && \
	mv init.vim ~/.config/nvim/

# Change editor variable to nvim
export EDITOR=$(which nvim)
echo -e "export EDITOR=$(which nvim)" >> ~/.bashrc
echo -e "export EDITOR=$(which nvim)" >> ~/.zshrc

# Modify new .zshrc and add aliases
SET_ALIASES=(   \
vim=nvim        \
)

for a in ${SET_ALIASES[*]}; do
	echo -e "alias $a" >> ~/.zshrc
done

# Grab and run Miniconda install script
pacaur -Sy miniconda3 --noconfirm

# Attempt to add conda to path
echo -e "Attempting to add conda to path..."
echo -e "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.zshrc && \
    echo -e "Success!"

# Install Oh-My-Zsh
#echo -e "Installing Oh-My-Zsh. REMEMBER TO CTRL-D OR EXIT OUT OF SHELL TO FINISH SCRIPT"
#sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
	mv ~/.zshrc ~/.zshrc.old && \
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
	cat ~/.zshrc.old >> ~/.zshrc && \
	rm ~/.zshrc.old && \
	chsh -s /bin/zsh

# After exit, re-source .zshrc
#cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc

printf \
"Everything should be installed!\n\
Make sure to do the following to finish up:\n\
- Log out and log back in\n\
- type \"base16_eighties\" in a new terminal\n\
- edit the ~/.config/nvim/init.vim file and :PlugInstall\n\
- edit the ~/.zshrc settings\n"
