#!/bin/bash
read -p " are you sure ? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo"y/n"
#aria2 config 
cat <<EOF>>/root/.config/aria2/aria2.conf
continue=true
daemon=true
dir=/home/$SUDO_USER/Downloads/
max-concurrent-downloads=5
seed-ratio=0
max-connection-per-server=16
split=16
EOF
#aria2 tmux script
cat <<EOF>/usr/bin/tmuxsc.sh
#!/bin/bash
tmux new-session -d -s sa31 'aria2c --enable-rpc --rpc-listen-all --continue=true --force-save=true'
EOF
#aria2 tmux service 
cat <<EOF>/etc/systemd/system/tmuxaria2.service
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