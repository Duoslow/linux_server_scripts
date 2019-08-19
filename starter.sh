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
#
# Purpose - display current system date & time
#
function web(){
	    
echo percentage | dialog --gauge "text" height width percent
#basit kurulumlar
counter=0
(
# set infinite while loop
while :
do
cat <<EOF
XXX
$counter
Kuruluma başlanıyor ( $counter%):
XXX
EOF
# increase counter by 10
(( counter+=1 ))
[ $counter -eq 10 ] && break
# delay it a specified amount of time i.e 1 sec
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
#
# Purpose - display a calendar
#
function home(){
	echo "$ROOT_USER" >$OUTPUT
	display_output 13 25 "Home Server"
}
#
# set infinite loop
#
function basic(){
	echo "$ROOT_USER" >$OUTPUT
	display_output 13 25 "Basic Server"
}
while true
do

### display main menu ###
dialog --clear  --help-button --backtitle "starter script by ST4RDUST" \
--title "[ S T A R T E R M E N U ]" \
--menu "Yukarı ve Aşağı tuşlarını kullanarak menü yü kontrol edebilirsin \n\
Sağ ve Sol tuşlarını kullanarak alt menü yü kontrol edebilirsin \n\
İşlem Seç" 15 50 4 \
webserver "Web Server" \
homeserver "Home Server" \
basicserver "Basic start" \
Exit "Çıkış" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# make decsion 
case $menuitem in
	webserver) web;;
	homeserver) home;;
	basicserver) basic;;
	Exit) echo "Bye"; break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
clear


