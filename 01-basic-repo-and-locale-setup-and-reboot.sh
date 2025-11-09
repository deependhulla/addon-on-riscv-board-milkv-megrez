#!/bin/bash

# Script: 01-basic-repo-and-locale-setup-and-reboot.sh
# Purpose: Performs initial setup for a RockOS (Debian 13) installation,
#          including package updates, essential tools installation,
#          timezone/locale configuration, and system hardening/convenience settings.

# Use non-interactive mode for all subsequent Debian package configurations
DEBIAN_FRONTEND=noninteractive

## 1. System Cleanup and Upgrade
############################################################

# Remove specific, often unwanted, game data package (e.g., to save space/resources)
apt -y remove --purge supertuxkart-data

# Update the package lists from the repositories
apt update
# Perform a full system upgrade (recommended for major updates)
apt -y full-upgrade

## 2. Essential Package Installation
############################################################

# Install a set of essential and convenience packages.
# Note: Some may be present by default, but this ensures they are installed.
apt -y install ifupdown openssh-server locales whiptail vim auditd curl screen net-tools \
git mc tmux parted gdisk debconf-utils pwgen apt-transport-https software-properties-common \
zstd ethtool dirmngr ca-certificates elinks wget python3-full python3-pip

# Install Chrony for accurate network time synchronization and remove  default time sync package
apt -y install chrony

# Install device-tree-compiler (dtc) for working with Device Tree Source (.dts) and
# Device Tree Blob (.dtb) files, which is essential for kernel/hardware configuration (e.g., RAM changes on Eswin).
apt -y install device-tree-compiler 

# Install build tools essential for compiling applications from source code
apt -y install build-essential cmake libcurl4-openssl-dev golang-go

## 3. Timezone and Locale Setup
############################################################

# Set the system timezone to India Standard Time (IST)
# NOTE: Change 'Asia/Kolkata' to your desired timezone if necessary.
timedatectl set-timezone 'Asia/Kolkata'

# Reconfigure the timezone data non-interactively
dpkg-reconfigure -f noninteractive tzdata

# Set environment variables for locale to ensure proper character encoding (English/US UTF-8)
export LANG=C
export LC_CTYPE=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Uncomment en_US.UTF-8 in /etc/locale.gen to ensure it's generated
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

# Comment out a potentially conflicting locale (like Indian English) if present
sed -i -e 's/en_IN UTF-8/# en_IN UTF-8/' /etc/locale.gen

# Generate the specified locales
locale-gen en_US en_US.UTF-8

# Persist locale settings system-wide in /etc/environment
echo "LANG=en_US.UTF-8" > /etc/environment
echo "LC_ALL=en_US.UTF-8" >> /etc/environment

# Update the system locale configuration
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

## 4. Python Virtual Environment Setup
############################################################
# Create a Python virtual environment for the root user in /opt/venv
python3 -m venv /opt/venv

# Automatically activate the virtual environment upon root login by adding
# the activation command to the root user's .bashrc
echo "" >> /root/.bashrc
echo "source /opt/venv/bin/activate" >> /root/.bashrc

## 5. Network Configuration and System Aliases
############################################################

# Disable IPv6 immediately for the current session (for all and default interfaces)
# This is often done in environments where IPv6 is not required or may cause issues.

sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null

# Configure CentOS/RHEL-like shell aliases and environment variables for all interactive users
# These aliases provide protection against accidental overwrites/deletions (-i) and
# improve the readability of directory listings (--color=auto).

echo "" >> /etc/bash.bashrc
# Interactive copy
echo "alias cp='cp -i'" >> /etc/bash.bashrc
# List dot files
echo "alias l.='ls -d .* --color=auto'" >> /etc/bash.bashrc
# Long listing format
echo "alias ll='ls -l --color=auto'" >> /etc/bash.bashrc
# Colored list output
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
# Interactive move
echo "alias mv='mv -i'" >> /etc/bash.bashrc
# Interactive remove
echo "alias rm='rm -i'" >> /etc/bash.bashrc
# docker cli alias
echo "alias docker=podman'" >> /etc/bash.bashrc

# Set default editor to vi/vim , example for crontab -e
echo "export EDITOR=vi" >> /etc/bash.bashrc
# Re-export locale settings for user sessions
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LANGUAGE=en_US.UTF-8" >> /etc/bash.bashrc

## 6. /etc/rc.local and systemd Setup
############################################################

# Recreate /etc/rc.local (a legacy initialization script) for custom startup tasks
touch /etc/rc.local
# Add  persistent IPv6 disablement

printf '%s\n' '#!/bin/bash'  | tee -a /etc/rc.local 1>/dev/null
echo "sysctl -w net.ipv6.conf.all.disable_ipv6=1" >>/etc/rc.local
echo "sysctl -w net.ipv6.conf.default.disable_ipv6=1" >> /etc/rc.local
# Set swappiness to 0 (reduces how often the system swaps to disk, preferring RAM)
echo "sysctl vm.swappiness=0" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
# Make the script executable
chmod 755 /etc/rc.local

# Create a systemd unit file to enable compatibility with /etc/rc.local
# This is required on modern Debian/Linux distributions that use systemd.
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

# Enable and start the new rc-local service
systemctl enable rc-local
systemctl start rc-local

## 7. Configuration for Perl (CPAN) and Vim
############################################################

# Configure CPAN (Perl Archive Network) to automatically follow and install prerequisites
# The 'y', 'o conf prerequisites_policy follow', and 'o conf commit' answers are sent non-interactively
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan 1>/dev/null

# Configure Vim to disable automatic visual mode using the mouse in terminal (for better copy/paste via SSH)
# and enable syntax highlighting.
# For the root user (~/.vimrc)
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc
# For all new users (via /etc/skel/.vimrc)
echo "\"set mouse=a/g" >  /etc/skel/.vimrc
echo "syntax on" >> /etc/skel/.vimrc

## 8. SSH Configuration (Optional/Commented Out)
############################################################

# NOTE: The following lines are commented out. Uncomment them ONLY IF you understand the security implications.
# This section configures SSH for root login and changes the port (e.g., for in-house development).

## Uncomment this block if you want root login via SSH activated on port 5522.
## IMPORTANT: Set a strong password for root and the default user first!

#sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
#sed -i "s/#Port 22/Port 5522/g" /etc/ssh/sshd_config
#systemctl restart ssh

## 9. Final Cleanup and Reboot Prompt
############################################################

# Remove packages that were automatically installed to satisfy dependencies
# and are no longer needed (after the cleanup/purge at the start).
apt -y autoremove

# Display system status information for verification before reboot
echo "---------------------------------------------------------------------------"
date 
echo "---------------------------------------------------------------------------"
hostname -f
echo "---------------------------------------------------------------------------"
ping `hostname -f` -c 2
echo "---------------------------------------------------------------------------"
echo "Please check that hostname and time are properly set."
echo "Please Reboot once to apply all kernel and permanent configuration changes."

echo "---------------------------------------------------------------------------"

