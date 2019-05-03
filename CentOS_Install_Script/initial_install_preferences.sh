#!/usr/bin/sh

# Check before script starts to make sure base16 shell can install correctly.
if [ ! -e base16_zshrc ]
	then echo -e "Can't find base16_zshrc"; exit 1;
fi

echo "This should install all of the things I normally want on a new install."

# List of system packages to install
PACKAGES=(      \
wget            \
git             \
zsh             \
util-linux-ng	\
neovim          \
)

sudo yum install ${PACKAGES[*]} -y

# Set up git config settings
git config --global user.name "Alex Huddleston"
git config --global user.email adh9694@gmail.com

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && \
    ./install.sh && \
    cd ../ && \
    sudo rm -r fonts

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

# Modify new .zshrc and add aliases
SET_ALIASES=(   \
vim=nvim        \
)

for a in ${SET_ALIASES[*]}; do
	echo -e "alias $a" >> ~/.zshrc
done

# Grab and run Miniconda install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
	sudo chmod +x Miniconda3-latest-Linux-x86_64.sh && \
	./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 && \
	rm Miniconda3-latest-Linux-x86_64.sh && \
	echo -e "source /home/shadow8t4/miniconda3/etc/profile.d/conda.sh" >> ~/.zshrc

# Add VSCode Repo and install
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
	sudo yum check-update && \
	sudo yum install code -y

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
