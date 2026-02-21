#!/bin/bash 

sudo xbps-install -uy xbps
sudo xbps-install -Syu

sudo xbps-install -y glibc-locales

sudo sed -i 's/#uk_UA.UTF-8 UTF-8/uk_UA.UTF-8 UTF-8/' /etc/default/libc-locales
sudo xbps-reconfigure -f glibc-locales

echo "LANG=uk_UA.UTF-8" | sudo tee /etc/locale.conf
echo "Ласкаво прошу до збірки Vyshivka. Слава Україні!"

sudo xbps-install -S && sudo xbps-pkgdb -a 
