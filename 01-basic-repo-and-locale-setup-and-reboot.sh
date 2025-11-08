#!/bin/bash

DEBIAN_FRONTEND=noninteractive


## remove of game data
apt-get remove --purge supertuxkart-data

apt-get update
apt -y full-upgrade
## my few packages to install even if its there default at times ....
apt -y install ifupdown openssh-server locales whiptail vim auditd curl screen net-tools \
git mc tmux parted gdisk debconf-utils pwgen apt-transport-https software-properties-common \
ethtool dirmngr ca-certificates elinks wget

## install chrony and remove default timesync package
apt -y install chrony

## set to India IST timezone -- You can change as per your timezone
timedatectl set-timezone 'Asia/Kolkata'
dpkg-reconfigure -f noninteractive tzdata

export LANG=C
export LC_CTYPE=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/en_IN UTF-8/# en_IN UTF-8/' /etc/locale.gen
locale-gen en_US en_US.UTF-8
echo "LANG=en_US.UTF-8" > /etc/environment
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

##disable ipv6 as most time not required
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null

## centos like bash ..for all inteactive 
echo "" >> /etc/bash.bashrc
echo "alias cp='cp -i'" >> /etc/bash.bashrc
echo "alias l.='ls -d .* --color=auto'" >> /etc/bash.bashrc
echo "alias ll='ls -l --color=auto'" >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias mv='mv -i'" >> /etc/bash.bashrc
echo "alias rm='rm -i'" >> /etc/bash.bashrc
echo "export EDITOR=vi" >> /etc/bash.bashrc
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LANGUAGE=en_US.UTF-8" >> /etc/bash.bashrc

## create rc.local  with default IPV6 disabled
touch /etc/rc.local
printf '%s\n' '#!/bin/bash'  | tee -a /etc/rc.local 1>/dev/null
echo "sysctl -w net.ipv6.conf.all.disable_ipv6=1" >>/etc/rc.local
echo "sysctl -w net.ipv6.conf.default.disable_ipv6=1" >> /etc/rc.local
echo "sysctl vm.swappiness=0" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod 755 /etc/rc.local
## need like autoexe bat on startup for some activity ..as a old linux user
echo "[Unit]" > /etc/systemd/system/rc-local.service
echo " Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
echo " ConditionPathExists=/etc/rc.local" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Service]" >> /etc/systemd/system/rc-local.service
echo " Type=forking" >> /etc/systemd/system/rc-local.service
echo " ExecStart=/etc/rc.local start" >> /etc/systemd/system/rc-local.service
echo " TimeoutSec=0" >> /etc/systemd/system/rc-local.service
echo " StandardOutput=tty" >> /etc/systemd/system/rc-local.service
echo " RemainAfterExit=yes" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Install]" >> /etc/systemd/system/rc-local.service
echo " WantedBy=multi-user.target" >> /etc/systemd/system/rc-local.service

systemctl enable rc-local
systemctl start rc-local


## make cpan auto yes for pre-requist modules of perl , when used
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan 1>/dev/null

#Disable vim automatic visual mode using mouse ..so copy paste from ssh and vi file open become easy
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc
##  for  other new users
echo "\"set mouse=a/g" >  /etc/skel/.vimrc
echo "syntax on" >> /etc/skel/.vimrc

##Comment this if you do not want root login via ssh activated using port 5522 , i use inhouse for developmrnt most
## but do set passwrod for root and debian user strong first.
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/#Port 22/Port 5522/g" /etc/ssh/sshd_config
systemctl restart ssh


## remove old package or removed one
apt -y autoremove
echo "---------------------------------------------------------------------------"
date 
echo "---------------------------------------------------------------------------"
hostname -f
echo "---------------------------------------------------------------------------"
ping `hostname -f` -c 2
echo "---------------------------------------------------------------------------"
echo "Please Check hostname & time is proper set"
echo "Please Reboot once."

echo "---------------------------------------------------------------------------"

