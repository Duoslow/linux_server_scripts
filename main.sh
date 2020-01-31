#!/bin/bash
sudo apt-add-repository ppa:ondrej/php -y > /dev/null
sudo apt-get update  -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null
sudo apt-get -y install git tmux aria2 -qq > /dev/null
sudo apt-get -y install apache2 python3-pip -qq > /dev/null
sudo apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-gd php7.0-cli php7.0-dev mcrypt p7zip-full php7.0-mbstring -qq > /dev/null
sudo ufw allow 'Apache'
function zsh (){
sudo apt-get -y install powerline fonts-powerline
sudo apt-get -y install zsh-theme-powerlevel9k
echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc
sudo apt-get -y install zsh-syntax-highlighting
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
}
while true; do
    read -p "Install zsh ?" yn
    case $yn in
        [Yy]* ) eval "zsh ."; break;;
        [Nn]* ) echo "Not installing: zsh" ; break ;;
        * ) echo "Y/N";;
    esac
done