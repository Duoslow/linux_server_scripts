#!/bin/bash
read -p "Merhaba $USER Kurulum minimum 15-30dk sürecek kuruluma devam etmek istiyor musun ? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

#basit kurulumlar
sudo -i
apt-add-repository ppa:ondrej/php
apt-get update  -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get -y install git tmux aria2 -qq > /dev/null
# ---------------------------------------------------------------------------------------------------------------------
# WEB SERVER
# ---------------------------------------------------------------------------------------------------------------------
apt-get -y install apache2 python3-pip -qq > /dev/null
apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-gd php7.0-cli php7.0-dev mcrypt p7zip-full php7.0-mbstring -qq > /dev/null
ufw allow 'Apache'
chown -R $SUDO_USER:www-data /var/www/html/
chmod -R 770 /var/www/html/
mkdir -p /root/.config/aria2
touch /usr/bin/tmuxsc.sh
touch /etc/systemd/system/tmuxaria2.service
touch /root/.config/aria2/aria2.conf
chmod -R 770 /usr/bin/tmuxsc.sh
chmod -R 770 /etc/systemd/system/tmuxaria2.service
chmod -R 770 /root/.config/aria2/aria2.conf
# ---------------------------------------------------------------------------------------------------------------------
#aria2 config oluşturma
cat <<EOF>>/root/.config/aria2/aria2.conf
continue=true
daemon=true
dir=/home/$SUDO_USER/Downloads/
max-concurrent-downloads=5
seed-ratio=0
max-connection-per-server=16
split=16
EOF
# ---------------------------------------------------------------------------------------------------------------------
#aria2 tmux scripti
cat <<EOF>/usr/bin/tmuxsc.sh
#!/bin/bash
tmux new-session -d -s sa31 'aria2c --enable-rpc --rpc-listen-all --continue=true --force-save=true'
EOF
# ---------------------------------------------------------------------------------------------------------------------
#aria2 tmux service olusturma
cat <<EOF>/etc/systemd/system/tmuxaria2.service
[Unit]
Description=tmuxariascript
Documentation=none
After=network.target local-fs.target
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
chmod 777 /root/.config/aria2/aria2.conf
chmod 777 /usr/bin/tmuxsc.sh
chmod 777 /etc/systemd/system/tmuxaria2.service
# ---------------------------------------------------------------------------------------------------------------------
# KULLANICI ONAYLARI
# ---------------------------------------------------------------------------------------------------------------------
#Netdata
while true; do
    read -p "Netdata kurulsun mu ?" yn
    case $yn in
        [Yy]* ) bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive; break;;
        [Nn]* ) echo "Netdata Kurulmuyacak!" ; break ;;
        * ) echo "Y veya N ile cevap ver";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#Jellyfin
while true; do
    read -p "Jellyfin kurulsun mu ?" yn
    case $yn in
        [Yy]* ) jelly; break;;
        [Nn]* ) echo "Jellyfin Kurulmuyacak!" ; break ;;
        * ) echo "Y veya N ile cevap ver";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#Samba Kurulumu
while true; do
    read -p "samba kurulsun mu ?" yn
    case $yn in
        [Yy]* ) sambaconf; break;;
        [Nn]* ) echo "samba Kurulmuyacak!" ; break ;;
        * ) echo "Y veya N ile cevap ver";;
    esac
done
# ---------------------------------------------------------------------------------------------------------------------
#FONKSİYONLAR
# ---------------------------------------------------------------------------------------------------------------------
sambaconf()
{
apt-get -y install samba
cat <<EOF>>/etc/samba/smb.conf
[home-nas]
    comment = $SUDO_USER' NAS
    path = /home/$SUDO_USER/Downloads/
    read only = no
    browsable = yes
EOF
service smbd restart
while [ "$stat" != "Active: active" ];
do
stat="$(systemctl status smbd --output=short-monotonic | grep -Po "Active: active")"
        echo "servis ile bağlantı kuruluyor..."
        sleep 1
        if [[ "$stat" == "Active: active" ]]; then
echo "servis ile bağlantı kuruldu."
break
        fi
done
echo"Samba giriş bilgileri için $SUDO_USER kullanıcısı için şifre girin"
smbpasswd -a $SUDO_USER
ip="$(hostname -I | awk '{ print $1 }')"
echo -e "samba \e[32mkuruldu\e[39m buradan(\e[91m$ip/home-nas\e[39m)bağlanabilirsin"
}
# ---------------------------------------------------------------------------------------------------------------------
#jellyfin
jelly()
{
apt install apt-transport-https -y
add-apt-repository universe -y
wget -O - https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu $( lsb_release -c -s ) main" | tee /etc/apt/sources.list.d/jellyfin.list
apt update
apt install jellyfin -y
systemctl restart jellyfin
}