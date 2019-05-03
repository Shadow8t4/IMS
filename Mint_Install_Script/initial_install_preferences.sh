#!/bin/bash

# OS Detection
# something like:
#	cat /etc/os-release | grep ID_LIKE && \
#		grep (Debian, Arch, RHEL, etc) || \
#		cat /etc/os-release | grep ID && \
#			grep (Debian, Arch, RHEL, etc)

# Check before script starts to make sure base16 shell can install correctly.
if [ ! -e base16_zshrc ]
	then echo -e "Can't find base16_zshrc"; exit 1;
fi

echo -e "This should install all of the things I normally want on a new install."

# List of system packages to install
PACKAGES=(                  	\
	wget                        \
	git                         \
	zsh                         \
	fonts-powerline             \
	util-linux	                \
	neovim                      \
	curl                        \
	python3						\
	python3-pip					\
	python3-dev					\
	python3-setuptools			\
	software-properties-common  \
	default-openjdk				\
	default-openjre				\
)

sudo apt install ${PACKAGES[*]} -y

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
	mv init.vim ~/.config/nvim/ && \
	nvim + 'PlugInstall --sync' +qa

# Grab and run Miniconda install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
	sudo chmod +x Miniconda3-latest-Linux-x86_64.sh && \
	./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 && \
	rm Miniconda3-latest-Linux-x86_64.sh && \
	echo -e "source /home/shadow8t4/miniconda3/etc/profile.d/conda.sh" >> ~/.zshrc

# Add VSCode Repo and install
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
	sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
	sudo apt install apt-transport-https -y && \
	sudo apt update && \
	sudo apt install code -y && \
    rm microsoft.gpg

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

# Install Rust with default settings
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-host $(uname -m)-unknown-linux-gnu --default-toolchain stable -y && \
	echo export PATH="/home/shadow8t4/.cargo/bin:$PATH" >> ~/.zshrc

# Pre-install VSCode Plugin Prerequistites
PIP_PLUGINS=(	\
	pylint		\
	thefuck		\
)

sudo pip3 install ${PIP_PLUGINS[*]}

# Install VSCode Plugins
CODE_PLUGINS=(							\
	donjayamanne.python-extension-pack	\
	ms-vscode.cpptools					\
	vscjava.vscode-java-debug			\
	andrsdc.base16-themes				\
	abusaidm.html-snippets				\
	ecmel.vscode-html-css				\
	xabikos.javascriptsnippets			\
	rust-lang.rust						\
)

for p in ${CODE_PLUGINS[*]}; do
	code --install-extension $p
done

# Set Python default link to python3
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
	sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 2 && \
	sudo update-alternatives --set python /usr/bin/python3

# Add thefuck alias
echo -e "eval $(thefuck --alias)" >> ~/.zshrc

# Modify new .zshrc and add aliases
SET_ALIASES=(   \
	vim=nvim    \
	pip=pip3	\
)

for a in ${SET_ALIASES[*]}; do
	echo -e "alias $a" >> ~/.zshrc
done

# Set base16_eighties theme for zsh shell
echo -e "[ \$BASE16_THEME = \"base16-eighties\" ] && : || source ~/.config/base16-shell/scripts/base16-eighties" >> ~/.zshrc

# Change .zshrc plugin settings & theme
ZSH_PLUGINS=(	\
	git			\
	ssh-agent	\
)

sed -E -i -e "s/^plugins=\(([A-Za-z, \+\n\t\\\-])+\)$/plugins=($ZSH_PLUGINS)/gm" ~/.zshrc
# Write regex sed command to change theme later, go to bed.

# Instructions for after the script
printf \
"Everything should be installed!\n\
Make sure to do the following to finish up:\n\
- Log out and log back in\n\
- edit the ~/.zshrc settings\n"
