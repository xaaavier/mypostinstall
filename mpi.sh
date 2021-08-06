#!/bin/bash
## Variables
### Logiciels à supprimer
### Logiciels à ajouter
addsoftwares="terminator powerline filezilla keepassxc gimp wget optimizer evolution libreoffice-langpack-fr lollypop qownnotes tcpdump gnome-tweaks gnome-extensions-app vivaldi-stable wireshark gnome-shell-extension-user-theme gnome-shell-extension-gsconnect picard balena-etcher-electron sublime-text virt-manager libvirt"

if [[ $EUID -ne 0 ]]
then
	sudo chmod +x $(dirname $0)/$0
	sudo $(dirname $0)/$0
	exit;
fi

## Mise en place des focntions
### Optimisations
#### Choix du miroir le plus rapide
function optimisations() {
`isfm=$(grep -c fastestmirror /etc/dnf/dnf.conf)
	if [[ "$isfm" -eq "0" ]]
		then
			`echo "fastestmirror=1" >> /etc/dnf/dnf.conf` 2>/dev/null
	fi` 2>/dev/null
#### Réduit la taille des mise à jour
`isdr=$(grep -c deltarpm /etc/dnf/dnf.conf)
	if [[ "$isfr" -eq "0" ]]
		then
			`echo "deltarpm=true" >> /etc/dnf/dnf.conf` 2>/dev/null
	fi` 2>/dev/null
clear
}

### Sécurité
#### SELinux
seL=sestatus | grep "Current mode" | cut -f2 -d":" | tr -d " "
function security() {
echo -e '\n\e[0;36m'"Dans quel mode SELinux doit-il être éxécuté? Actuellement :\e[1m\e[31m`sestatus | grep "Current mode" | cut -f2 -d":" | tr -d " "`\e[0m"'\e[0;35m'
echo -e " \e[1;32menforcing\e[0;m : accès restreints \n \e[1;32mpermissive\e[0;m : les règles SELinux sont interrogées, les erreurs sont logguées mais rien n'est bloqué \n \e[1;32mdisabled\e[0;m  : accès non restreint, rien n’est enregistré"
	read selinux
		if [ "$selinux" = 'enforcing' -o "$selinux" = 'permissive' -o "$selinux" = 'disabled' ]
			then
				sed -e "s/SELINUX=.*/SELINUX=$selinux/" -i /etc/sysconfig/selinux
		fi
		echo -e '\e[0;31m'SELinux sera en mode $selinux au prochain redémarrage!'\e[0;m'
#### SSH
##### Server
echo -e '\n\e[0;36m'"Activer le serveur SSH? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
	read ssh
		if [ "$ssh" = 'o' ]
			then
				`systemctl enable --now sshd.service` 2>/dev/null
				echo -e '\e[0;31m'Le serveur SSH est maintenant activé!'\e[0;m'
			else
				echo
		fi
##### Client
echo -e '\n\e[0;36m'"Authoriser l'utilisation de clefs RSA? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
	read sshc
		if [ "$sshc" = 'o' ]
			then
				`update-crypto-policies --set LEGACY` 2>/dev/null
				echo -e '\e[0;31m'Clefs RSA authorisée.'\e[0;m'
			else
				echo
		fi
clear
}

### Dépots
function repository() {
#### Ajout Dépot
##### RPM Fusion Free
`dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y` 2>/dev/null
echo -e '\e[0;31m'Le dépot RPM Fusion FREE est maintenant installé!'\e[0;m'
##### RPM Fusion nonFree
`dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y` 2>/dev/null
echo -e '\e[0;31m'Le dépot RPM Fusion NON-FREE est maintenant installé!'\e[0;m'
##### Third Party Software
`dnf install fedora-workstation-repositories -y` 2>/dev/null
echo -e '\e[0;31m'"Third party software activé!"
##### flathub
`flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo` 2>/dev/null
echo -e '\e[0;31m'"Le dépot Flathub est installé.."'\e[0;m'
##### Vivaldi
`dnf install dnf-utils -y` 2>/dev/null
`dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo` 2>/dev/null
echo -e '\e[0;31m'"Le dépot de Vivaldi est installé.."'\e[0;m'
##### Balena Etcher
`curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | sudo -E bash` 2>/dev/null
echo -e '\e[0;31m'"Le dépot de Balena Etcher est installé.."'\e[0;m'
##### Sublime
`rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg && dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo` 2>/dev/null
echo -e '\e[0;31m'"Le dépot Sublime est installé.."'\e[0;m'
}

### Pilotes
function drivers() {
#### Ajout pilotes
##### Nvidia
echo -e '\n\e[0;36m'"Installer les pilotes Nvidia? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addnvidia
if [ "$addnvidia" = 'o' ]
	then 
		`dnf install xorg-x11-drv-nvidia akmod-nvidia xorg-x11-drv-nvidia-cuda -y` 2>/dev/null
		echo -e '\e[0;31m'"Pilotes Nvidia installés!"'\e[0;m'
	else
		echo
fi
# Broadcom
echo -e '\n\e[0;36m'"Installer les pilotes Broadcom? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addbroadcom
if [ "$addbroadcom" = 'o' ]
	then 
		`dnf install akmod-wl -y` 2>/dev/null
		echo -e '\e[0;31m'"Pilotes Broadcom installés!"'\e[0;m'
	else
		echo
fi
}
### Logiciels préinstallés
function bloatwares() {
`dnf autoremove baobab cheese epiphany gnome-{boxes,software,calendar,characters,clocks,contacts,dictionary,font-viewer,logs,maps,photos,user-docs,weather,tour,terminal} rhythmbox totem gedit gucharmap sushi abrtd* yelp gnome-shell-extension-{apps-menu,background-logo,launch-new-instance,window-list,places-menu} -y` 2>/dev/null
echo -e '\e[0;31m'"Logiciels préinstallé supprimé!"'\e[0;m'
}
### Mise à jour
function update() {
echo -e '\n\e[0;36m'"Mise à jour en cours, merci de patienter"
`dnf upgrade -y` 2>/dev/null
}
### Ajout de logiciel
function software_add() {
#### Codecs
`dnf group upgrade --with-optional Multimedia -y` 2>/dev/null
echo -e '\e[0;31m'"Codecs supplémentaires installés!"'\e[0;m'
`dnf install $addsoftwares -y` 2>/dev/null
#Commenter la ligne ci-dessous s'il wireshark n'est pas installé
`usermod -a -G wireshark `who | cut -f1 -d":"` 2>/dev/null
#Commenter les lignes ci-dessous si virt-manager n'est pas installé
`groupadd --system libvirt` 2>/dev/null
`usermod -a -G libvirt `who | cut -f1 -d":"` 2>/dev/null
`sed -i -e "s/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g" /etc/libvirt/libvirtd.conf` 2>/dev/null
`sed -i -e "s/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g" /etc/libvirt/libvirtd.conf` 2>/dev/null
echo -e '\e[0;31m'"Logiciels installés!"'\e[0;m'
}
### Reboot
function reboot() {
reboot
}
### Menu
menu(){
echo "  __  __        ___        _   ___         _        _ _ _ ";
echo " |  \/  |_  _  | _ \___ __| |_|_ _|_ _  __| |_ __ _| | ( )";
echo " | |\/| | || | |  _/ _ (_-|  _|| || ' \(_-|  _/ _\` | | |/ ";
echo " |_|  |_|\_, | |_| \___/__/\__|___|_||_/__/\__\__,_|_|_|  ";
echo "         |__/                                             ";
echo -ne "

\e[0;32m1)\e[0;m Optimisations
\e[0;32m2)\e[0;m Sécurité
\e[0;32m3)\e[0;m Dépots
\e[0;32m4)\e[0;m Pilotes 
\e[0;32m5)\e[0;m Logiciels préinstallés
\e[0;32m6)\e[0;m Mise à jour
\e[0;32m7)\e[0;m Ajout de logiciels
\e[0;32m8)\e[0;m Reboot
\e[0;32m9)\e[0;m One Shot
\e[0;32m0)\e[0;m Quitter
N'essaie pas! Fais-le ou ne le fais pas! Il n'y a pas d'essai: "
        read a
        case $a in
	        1) optimisations ; menu ;;
	        2) security ; menu ;;
	        3) repository ; menu ;;
	        4) drivers ; menu ;;
	        5) bloatwares ; menu ;;
		6) update ; menu ;;
		7) software_add ; menu ;;
		8) reboot ; menu ;;
		9) optimisations && security && repository && drivers && bloatwares && update && software_add ; menu ;;
		0) exit 0 ;;
		*) echo -e "\e[0;31mLa première fois cest une erreur, ensuite cest de l'obstination.\e[0;m" $clear; menu;;
        esac
}
clear
menu
