#!/bin/bash

echo "Pidgotovka!"

git pull origin main
sudo xbps-install -uy xbps
sudo xbps-install -Syu

sudo xbps-install -y glibc-locales

sudo sed -i 's/#uk_UA.UTF-8 UTF-8/uk_UA.UTF-8 UTF-8/' /etc/default/libc-locales
sudo xbps-reconfigure -f glibc-locales


echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
echo "LC_TIME=uk_UA.UTF-8" | sudo tee -a /etc/locale.conf


echo "-------------------------------------------------------"
echo "Ласкаво прошу до збірки Vyshivka. Слава Україні!"
echo "-------------------------------------------------------"


sudo xbps-install -S && sudo xbps-pkgdb -a 

sudo xbps-install -y xfce4 xfce4-plugins lightdm lightdm-gtk-greeter xorg-server xorg-video-drivers

# Менеджер входу (екран вітання)
sudo ln -s /etc/sv/lightdm /var/service/
# Мережа (щоб інтернет був відразу)
sudo ln -s /etc/sv/NetworkManager /var/service/
# Звук (Pipewire для стабільності)
sudo xbps-install -y pipewire pavucontrol

sudo mkdir -p /etc/skel/.config/xfce4
sudo cp -r configs/xfce4/* /etc/skel/.config/xfce4/
