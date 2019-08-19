#!/bin/bash

INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM
function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "starter script by ST4RDUST" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}
function web(){
	    
echo percentage | dialog --gauge "text" height width percent
#basit kurulumlar
counter=0
(
while :
do
cat <<EOF
XXX
$counter
Kuruluma başlanıyor ( $counter%):
XXX
EOF
(( counter+=1 ))
[ $counter -eq 10 ] && break
sleep 0.2
done
) |
dialog --title "Kurulum Başlıyor" --gauge "Lütfen Bekleyin" 7 70 0


echo "10" | dialog --gauge "Sistem Güncellemeleri Yükleniyor..." 10 70 0
sudo apt-get update -qq > /dev/null
echo "15" | dialog --gauge "Sistem Güncellemeleri Yükleniyor..." 10 70 0
sudo apt-get upgrade -y -qq > /dev/null
echo "20" | dialog --gauge "Sistem Güncellemeleri Yüklendi..." 10 70 0
sleep 0.3
echo "25" | dialog --gauge "Web Server kurulumu başlıyor ..." 10 70 0
sleep 0.3
echo "30" | dialog --gauge "apache2 kuruluyor ..." 10 70 0
sudo apt-get -y install git apache2 tmux -qq > /dev/null
echo "35" | dialog --gauge "apache2 kuruldu ..." 10 70 0
sleep 0.3
echo "40" | dialog --gauge "php kuruluyor ..." 10 70 0
sudo apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql -qq > /dev/null
echo "45" | dialog --gauge "php kuruluyor ..." 10 70 0
sudo apt-get -y install php7.0-gd php7.0-cli php7.0-dev mcrypt p7zip-full php7.0-mbstring -qq > /dev/null
echo "50" | dialog --gauge "php kuruldu ..." 10 70 0
sleep 0.3
echo "55" | dialog --gauge "python3 kuruluyor ..." 10 70 0
sudo apt-get -y install libav-tools python3-pip -qq > /dev/null
echo "60" | dialog --gauge "python3 kuruldu ..." 10 70 0
sleep 0.3
echo "65" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
sudo apt-get -y install ufw bind9 mysql-client -qq > /dev/null
echo "70" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
sudo ufw allow 'Apache'
echo "80" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
sudo chown -R $SUDO_USER:www-data /var/www/html/
echo "90" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
sudo chmod -R 770 /var/www/html/
echo "100" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
sudo mkdir -p /root/.config/aria2
echo "100" | dialog --gauge "son düzenlemeler yapılıyor..." 10 70 0
display_output 6 60 "kurulum tamamlandı"

}

function home(){
	sudo apt-get update -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null
sudo apt-get -y install git tmux aria2  -qq > /dev/null
# ---------------------------------------------------------------------------------------------------------------------
# WEB SERVER
# ---------------------------------------------------------------------------------------------------------------------
sudo apt-get -y install apache2 php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-gd php7.0-cli php7.0-dev mcrypt p7zip-full libav-tools python3-pip php7.0-mbstring -qq > /dev/null
sudo ufw allow 'Apache' >/dev/null
sudo chown -R $SUDO_USER:www-data /var/www/html/ >/dev/null
sudo chmod -R 770 /var/www/html/ >/dev/null
sudo mkdir -p /root/.config/aria2 >/dev/null
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
sudo chmod 777 /root/.config/aria2/aria2.conf >/dev/null
sudo chmod 777 /usr/bin/tmuxsc.sh >/dev/null
sudo chmod 777 /etc/systemd/system/tmuxaria2.service >/dev/null
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
sudo apt-get -y install samba -qq >/dev/null

cat <<EOF>>/etc/samba/smb.conf
[home-nas]
    comment = $SUDO_USER' NAS
    path = /home/$SUDO_USER/Downloads/
    read only = no
    browsable = yes
EOF

sudo service smbd restart
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
sudo smbpasswd -a $SUDO_USER
ip="$(hostname -I | awk '{ print $1 }')"
echo -e "samba \e[32mkuruldu\e[39m buradan(\e[91m$ip/home-nas\e[39m)bağlanabilirsin"
}
# ---------------------------------------------------------------------------------------------------------------------
#jellyfin
jelly()
{
sudo apt install apt-transport-https -y
sudo add-apt-repository universe -y
wget -O - https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu $( lsb_release -c -s ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
sudo apt update
sudo apt install jellyfin -y
sudo systemctl restart jellyfin
}



	display_output 13 25 "Home Server"
}

function basic(){
	echo "$ROOT_USER" >$OUTPUT
	display_output 13 25 "Basic Server"
}
while true
do

### display main menu ###
dialog --clear  --help-button --backtitle "starter script by ST4RDUST" \
--title "[ S T A R T E R M E N U ]" \
--menu " \n\
 \n\
İşlem Seç" 15 50 6 \
webserver "Web Server" \
homeserver "Home Server" \
basicserver "Basic start" \
Exit "exit" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case $menuitem in
	webserver) web;;
	homeserver) home;;
	basicserver) basic;;
	Exit) echo "bb oc"; break;;
esac

done

[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
clear


