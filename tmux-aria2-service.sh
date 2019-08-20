#!/bin/bash
read -p " are you sure ? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
#create
sudo mkdir -p /root/.config/aria2
sudo touch /etc/tmuxsc.sh
sudo touch /etc/systemd/system/tmuxaria2.service
sudo touch /root/.config/aria2/aria2.conf
sudo chmod  777 /etc/tmuxsc.sh
sudo chmod  777 /etc/systemd/system/tmuxaria2.service
sudo chmod  777 /root/.config/aria2/aria2.conf
#aria2 config 
sudo -s cat <<EOF>>/root/.config/aria2/aria2.conf
continue=true
daemon=true
dir=/home/$USER/Downloads/
max-concurrent-downloads=5
seed-ratio=0
max-connection-per-server=16
split=16
EOF
#aria2 tmux script
sudo -s cat <<EOF>/etc/tmuxsc.sh
#!/bin/bash
tmux new-session -d -s sa31 'aria2c --enable-rpc --rpc-listen-all --continue=true --force-save=true'
EOF
#aria2 tmux service 
sudo -s cat <<EOF>/etc/systemd/system/tmuxaria2.service
[Unit]
Description=tmuxaria2cscript
Documentation=none

[Service]
Type=forking
KillMode=none
User=root
ExecStart=/etc/tmuxsc.sh

[Install]
WantedBy=default.target
EOF