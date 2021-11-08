#!/bin/bash
## Variables ##
### Environement ###
isfm=$(grep -c fastestmirror /etc/dnf/dnf.conf)
isfr=$(grep -c deltarpm /etc/dnf/dnf.conf)
ismd=$(grep -c max_parallel_downloads /etc/dnf/dnf.conf)
addsoftwares="terminator policycoreutils-gui menulibre remmina filezilla keepassxc gimp wget optimizer gnome-extensions-app thunderbird libreoffice-langpack-fr lollypop tcpdump guake gnome-tweaks chromium wireshark picard balena-etcher-electron arc-theme papirus-icon-theme"
addflatpak="com.anydesk.Anydesk md.obsidian.Obsidian io.freetubeapp.FreeTube org.libretro.RetroArch com.jgraph.drawio.desktop"
rmbloatware="baobab cheese epiphany gnome-{boxes,software,calendar,characters,clocks,contacts,dictionary,font-viewer,logs,maps,photos,user-docs,weather,tour,terminal} rhythmbox totem gucharmap sushi abrtd* yelp gnome-shell-extension-{apps-menu,background-logo,launch-new-instance,window-list,places-menu}"
### Colors ###
ESC=$(printf '\033')
RESET="${ESC}[0m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
BLUE="${ESC}[34m"
CYAN="${ESC}[36m"
## Fonctions ##
### Color Functions ###
function greenprint {
  printf "${GREEN}%s${RESET}\n" "$1";
}
function blueprint {
  printf "${BLUE}%s${RESET}\n" "$1";
}
function redprint {
  printf "${RED}%s${RESET}\n" "$1";
}
function cyanprint {
  printf "${CYAN}%s${RESET}\n" "$1";
}
function fail {
  echo "Do you think like you type?";
  sleep 3;
  mainmenu;
}
### Leave functions ###
function quit {
  echo "Press any key to continue.."
  while [ true ] ; do
    read -t 5 -n 1
    if [ $? = 0 ] ; then
      exit ;
    else
      echo -e "                                                                                   or another to exit.."
    fi
  done
}
function logo {
  echo "  __  __        ___        _   ___         _        _ _ _ ";
  echo " |  \/  |_  _  | _ \___ __| |_|_ _|_ _  __| |_ __ _| | ( )";
  echo " | |\/| | || | |  _/ _ (_-|  _|| || ' \(_-|  _/ _\` | | |/ ";
  echo " |_|  |_|\_, | |_| \___/__/\__|___|_||_/__/\__\__,_|_|_|  ";
  echo "         |__/                                             ";
}
## Menu ##
### Mainmenu ###
function mainmenu {
  logo
  echo -ne "
  $(blueprint 'MAIN MENU')
  $(greenprint '1)') Optimisations
  $(greenprint '2)') Security
  $(greenprint '3)') Hardware
  $(greenprint '4)') Softwares
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    submenu-optimisations
    mainmenu
    ;;
    2)
    submenu-security
    mainmenu
    ;;
    3)
    submenu-hardwares
    mainmenu
    ;;
    4)
    submenu-softwares
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### submenu-optimisations ###
submenu-optimisations() {
  logo
  echo -ne "
  $(blueprint 'OPTIMISATIONS')
  $(greenprint '1)') Choosing the fastest mirror
  $(greenprint '2)') Reduce updates size
  $(greenprint '3)') Increase the number of parallel downloads
  $(greenprint '6)') All in one!
  $(cyanprint '-)') Previous
  $(cyanprint '9)') Main menu
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    fm
    submenu-optimisations
    ;;
    2)
    drpm
    submenu-optimisations
    ;;
    3)
    mpd
    submenu-optimisations
    ;;
    6)
    fm
    drpm
    mpd
    submenu-optimisations
    ;;
    -)
    mainmenu
    ;;
    9)
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### submenu-security ###
submenu-security() {
  logo
  echo -ne "
  $(blueprint 'SECURITY')
  $(greenprint '1)') Make SELinux permissive
  $(greenprint '2)') SSH
  $(greenprint '3)') securityusr
  $(cyanprint '-)') Previous
  $(cyanprint '9)') Main menu
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    selpermissive
    submenu-security
    ;;
    2)
    submenu-ssh
    submenu-security
    ;;
    3)
    securityusr
    submenu-security
    ;;
    -)
    mainmenu
    ;;
    9)
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### sub-submenu-sshc ###
submenu-ssh() {
  logo
  echo -ne "
  $(blueprint 'SSH')
  $(greenprint '1)') Activate SSH server
  $(greenprint '2)') Enabling RSA key-based authentication
  $(greenprint '3)') Creating SSH keys
  $(greenprint '6)') All in one!
  $(cyanprint '-)') Previous
  $(cyanprint '9)') Main menu
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    sshs
    submenu-ssh
    ;;
    2)
    sshrsa
    submenu-ssh
    ;;
    3)
    sshc
    submenu-ssh
    ;;
    6)
    sshs
    sshrsa
    sshc
    submenu-ssh
    ;;
    -)
    submenu-security
    ;;
    9)
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### submenu-hardwares ###
submenu-hardwares() {
  logo
  echo -ne "
  $(blueprint 'HARDWARE')
  $(greenprint '1)') Drivers Nvidia
  $(greenprint '2)') Drivers Broadcom
  $(greenprint '3)') All in one!
  $(cyanprint '-)') Previous
  $(cyanprint '9)') Main menu
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    nvidia
    submenu-hardwares
    ;;
    2)
    broadcom
    submenu-hardwares
    ;;
    3)
    nvidia
    broadcom
    submenu-hardwares
    ;;
    -)
    mainmenu
    ;;
    9)
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### submenu-softwares ###
submenu-softwares() {
  logo
  echo -ne "
  $(blueprint 'SOFTWARES')
  $(greenprint '1)') Remove gnome-bloatwares
  $(greenprint '2)') Update
  $(greenprint '3)') Add repositorys
  $(greenprint '4)') Add softwares
  $(greenprint '6)') All in one!
  $(cyanprint '-)') Previous
  $(cyanprint '9)') Main menu
  $(redprint '0)') Leave
  Choose an option:  "
  read -r ans
  case $ans in
    1)
    gbloatwares
    submenu-softwares
    ;;
    2)
    updates
    submenu-softwares
    ;;
    3)
    addrepo
    submenu-softwares
    ;;
    4)
    addsoft
    submenu-softwares
    ;;
    6)
    gbloatwares
    updates
    addrepo
    addsoft
    submenu-softwares
    ;;
    -)
    mainmenu
    ;;
    9)
    mainmenu
    ;;
    0)
    quit
    ;;
    *)
    fail
    ;;
  esac
}
### Choosing the fastest mirror
function fm {
  if [[ "$isfm" -eq "0" ]]
		then
			`echo "fastestmirror=1" >> /etc/dnf/dnf.conf` >> /tmp/mpi.log
	fi
}
### Reduce updates size
function drpm {
if [[ "$isfr" -eq "0" ]]
  then
    `echo "deltarpm=true" >> /etc/dnf/dnf.conf` >> /tmp/mpi.log
fi
}
### Increase the number of parallel downloads
function mpd {
if [[ "$ismd" -eq "0" ]]
  then
    `echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf` >> /tmp/mpi.log
fi
}
### Make SELinux permissive
function selpermissive {
sed -e "s/SELINUX=.*/SELINUX=permissive/" -i /etc/sysconfig/selinux
}
### Activate SSH server
function securityusr {
echo "Defaults	rootpw" >> /etc/sudoers
}
### Activate SSH server
function sshs {
#### SSH server configuration file backup
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.back
#### Activating SSH
`systemctl enable --now sshd.service  >> /tmp/mpi.log`
#### Disabling root login
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
#### Changing connection port
r=$((1024 + RANDOM % 65535))
sed -i "s/#Port 22/Port $r/g" /etc/ssh/sshd_config
sudo semanage port -a -t ssh_port_t -p tcp "$r"
#### Restricting connections to the sshusers group
groupadd sshusers
usermod -aG sshusers "$USERNAME"
echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
#### Forbid access by password
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
#### SELinux configuration
semanage port -a -t ssh_port_t -p tcp $r
#### Firewall configuration
firewall-cmd --add-port=$r/tcp --permanent >> /tmp/mpi.log
firewall-cmd --remove-port=22/tcp --permanent >> /tmp/mpi.log
firewall-cmd --reload >> /tmp/mpi.log
#systemctl restart sshd
`systemctl restart sshd.service  >> /tmp/mpi.log`
echo -e "\e[0;31mLe serveur SSH est maintenant en écoute sur le port \e[41m\e[97m\e[1m$r\e[39m\e[0m\e[49m"
sleep 10
}
### Enabling RSA key-based authentication
function sshrsa {
    `update-crypto-policies --set LEGACY` >> /tmp/mpi.log
}
### Creating SSH keys
function sshc {
echo "Enter your email address "
read emladm
if [ "$sshc" = 'o' ]
  then
    printf '\n\n\n' | su -l "$USERNAME" -c "ssh-keygen -t rsa -b 4096 -C "$emladm""
    printf '\n\n\n' | su -l "$USERNAME" -c "ssh-keygen -b 4096 -C "$emladm""
  else
    printf '\n\n\n' | su -l "$USERNAME" -c "ssh-keygen -b 4096 -C "$emladm""
fi
}
### Drivers Nvidia
function nvidia {
`dnf install xorg-x11-drv-nvidia akmod-nvidia xorg-x11-drv-nvidia-cuda -y >> /tmp/mpi.log`
}
### Drivers Broadcom
function broadcom {
`dnf install akmod-wl -y >> /tmp/mpi.log`
}
### Remove gnome-bloatwares
function gbloatwares {
`dnf remove $rmbloatware -y    >> /tmp/mpi.log`
}
### Remove gnome-bloatwares
function updates {
`dnf upgrade -y    >> /tmp/mpi.log`
}
### Remove Add repositorys
function addrepo {
#### RPM Fusion Free
`dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y >> /tmp/mpi.log`
#### RPM Fusion nonFree
`dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y >> /tmp/mpi.log`
#### Third Party Software
`dnf install fedora-workstation-repositories -y >> /tmp/mpi.log`
#### flathub
`flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >> /tmp/mpi.log`
#### Balena Etcher
`curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | bash` >> /tmp/mpi.log
}
### Add softwares
function addsoft {
#### Codecs
`dnf group upgrade --with-optional Multimedia -y  >> /tmp/mpi.log`
### Softwares
`dnf install $addsoftwares -y  >> /tmp/mpi.log`
`dnf list installed | grep "wireshark"  >> /tmp/mpi.log`
	if [[ "$?" -eq "0" ]]
	then
    usermod -aG wireshark "$USERNAME"
	else
		:
	fi
### atom
`wget -q https://github.com/atom/atom/releases/download/v1.58.0/atom.x86_64.rpm  -P /tmp/`
`dnf install /tmp/atom.x86_64.rpm -y >> /tmp/mpi.log`
### flatpack
`flatpak install flathub $addflatpak -y  >> /tmp/mpi.log`
}
## Script ##
### super user do ###
function superuser {
if [[ $EUID -ne 0 ]]
then
	sudo chmod +x $(dirname $0)/$0
	sudo $(dirname $0)/$0
	exit;
fi
}
### display ###
superuser
tocuh /tmp/mpi.log
mainmenu
