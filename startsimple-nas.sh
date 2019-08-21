#!/bin/bash
read -p "Welcome $USER are you sure the installing? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
# ---------------------------------------------------------------------------------------------------------------------
#simple
# ---------------------------------------------------------------------------------------------------------------------
sudo apt-add-repository ppa:ondrej/php -y > /dev/null
sudo apt-get update  -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null
sudo apt-get -y install git tmux aria2 -qq > /dev/null
# ---------------------------------------------------------------------------------------------------------------------
# WEB SERVER
# ---------------------------------------------------------------------------------------------------------------------
sudo apt-get -y install apache2 python3-pip -qq > /dev/null
sudo apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-gd php7.0-cli php7.0-dev mcrypt p7zip-full php7.0-mbstring -qq > /dev/null
sudo ufw allow 'Apache'
sudo chown -R $SUDO_USER:www-data /var/www/html/
sudo chmod -R 770 /var/www/html/
sudo mkdir -p /root/.config/aria2
sudo touch /usr/bin/tmuxsc.sh
sudo touch /etc/systemd/system/tmuxaria2.service
sudo touch /root/.config/aria2/aria2.conf
sudo chmod  777 /usr/bin/tmuxsc.sh
sudo chmod  777 /etc/systemd/system/tmuxaria2.service
sudo chmod  777 /root
sudo chmod  777 /root/.config/aria2/aria2.conf
# ---------------------------------------------------------------------------------------------------------------------
#aria2 config
# ---------------------------------------------------------------------------------------------------------------------
sudo -s cat <<EOF>/root/.config/aria2/aria2.conf
continue=true
daemon=true
dir=/home/$USER/Downloads/
max-concurrent-downloads=5
seed-ratio=0
max-connection-per-server=16
split=16
EOF
# ---------------------------------------------------------------------------------------------------------------------
#aria2 tmux scripti
# ---------------------------------------------------------------------------------------------------------------------
sudo -s cat <<EOF>/usr/bin/tmuxsc.sh
#!/bin/bash
tmux new-session -d -s sa31 'aria2c --enable-rpc --rpc-listen-all --continue=true --force-save=true'
EOF
# ---------------------------------------------------------------------------------------------------------------------
#aria2 tmux service olusturma
# ---------------------------------------------------------------------------------------------------------------------
sudo -s cat <<EOF>/etc/systemd/system/tmuxaria2.service
[Unit]
Description=tmuxariascript
Documentation=none

[Service]
Type=forking
KillMode=none
User=root
ExecStart=/usr/bin/tmuxsc.sh

[Install]
WantedBy=default.target
EOF
# ---------------------------------------------------------------------------------------------------------------------
#izinler
# ---------------------------------------------------------------------------------------------------------------------
sudo chmod 777 /root/.config/aria2/aria2.conf
sudo chmod 777 /usr/bin/tmuxsc.sh
sudo chmod 777 /etc/systemd/system/tmuxaria2.service
sudo systemctl enable tmuxaria2.service  

# ---------------------------------------------------------------------------------------------------------------------
#FONKSİYONLAR
# ---------------------------------------------------------------------------------------------------------------------
function sambaconf ()
{
sudo apt-get -y install samba
sudo chmod 777 /etc/samba
sudo chmod 777 /etc/samba/smb.conf
sudo -s cat <<EOF>>/etc/samba/smb.conf
[home-nas]
    comment = $USER' NAS
    path = /home/$USER/Downloads/
    read only = no
    browsable = yes
EOF
sudo service smbd restart
while [ "$stat" != "Active: active" ];
do
stat="$(systemctl status smbd --output=short-monotonic | grep -Po "Active: active")"
        echo "connecting to smbd.service..."
        sleep 1
        if [[ "$stat" == "Active: active" ]]; then
echo "smbd.service connected"
break
        fi
done
echo "Samba $USER Password :"
sudo smbpasswd -a $USER
ip="$(hostname -I | awk '{ print $1 }')"
echo -e "samba \e[32mInstalled\e[39m(\e[91m$ip/home-nas\e[39m)"
}
# ---------------------------------------------------------------------------------------------------------------------
#jellyfin
# ---------------------------------------------------------------------------------------------------------------------
function jelly ()
{
sudo apt install apt-transport-https -y
sudo add-apt-repository universe -y
sudo wget -O - https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add -
sudo echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu $( lsb_release -c -s ) main" | tee /etc/apt/sources.list.d/jellyfin.list
sudo apt update
sudo apt install jellyfin -y
sudo systemctl restart jellyfin
}
# ---------------------------------------------------------------------------------------------------------------------
#motd
# ---------------------------------------------------------------------------------------------------------------------
function motd ()
{
sudo chmod -x /etc/update-motd.d/*
sudo apt install inxi screenfetch ansiweather
read -p 'Location :' location
sudo -s cat <<EOF>/etc/update-motd.d/01-custom
#!/bin/sh
echo "GENERAL SYSTEM INFORMATION"
/usr/bin/screenfetch
echo
echo "SYSTEM DISK USAGE"
export TERM=xterm; inxi -D
echo
echo "CURRENT WEATHER AT THE LOCATION"
# Show weather information. Change the city name to fit your location
ansiweather -l $location
EOF
}
# ---------------------------------------------------------------------------------------------------------------------
#netdata
# ---------------------------------------------------------------------------------------------------------------------
function netw{
ip="$(hostname -I | awk '{ print $1 }')"
echo -e "Netdata \e[32mInstalled\e[39m(\e[91m$ip:19999\e[39m)"

}
# ---------------------------------------------------------------------------------------------------------------------
#user
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
#Netdata
# ---------------------------------------------------------------------------------------------------------------------
while true; do
    read -p "Install Netdata ?" yn
    case $yn in
        [Yy]* ) bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive 
eval "netw ."
; break;;
        [Nn]* ) echo "Not installing: Netdata" ; break ;;
        * ) echo "Y/N";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#Jellyfin
# ---------------------------------------------------------------------------------------------------------------------
while true; do
    read -p "Install Jellyfin ?" yn
    case $yn in
        [Yy]* ) eval "jelly ."; break;;
        [Nn]* ) echo "Not installing: Jellyfin" ; break ;;
        * ) echo "Y/N";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#Samba
# ---------------------------------------------------------------------------------------------------------------------
while true; do
    read -p "Install Samba ?" yn
    case $yn in
        [Yy]* ) eval "sambaconf ." ; break;;
        [Nn]* ) echo "Not installing: samba" ; break ;;
        * ) echo "Y/N";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#motd
# ---------------------------------------------------------------------------------------------------------------------
while true; do
    read -p "change motd ?" yn
    case $yn in
        [Yy]* ) eval "motd ." ; break;;
        [Nn]* ) echo "Not changing: motd" ; break ;;
        * ) echo "Y/N";;
    esac
done