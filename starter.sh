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
echo "$ROOT_USER" >$OUTPUT
}

function home(){

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
select" 15 50 6 \
webserver "Web Server" \
homeserver "Home Server" \
basicserver "Basic start" \
RaspberryPI "Rasp pi web" \
System "Information" \
Others "Others"\
Exit "exit" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

case $menuitem in
	webserver) web;;
	homeserver) home;;
	basicserver) basic;;
    RaspberryPI) rasppi;;
    System) System;;
    Others) Others;;
	Exit) echo "bb oc"; break;;
esac

done

[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
clear


