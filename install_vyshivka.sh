#!/bin/bash

# Зупиняти скрипт при помилках
set -e

# Очистити термінал перед виводом лого
clear

echo -e "\e[34m" # Робимо текст синім (в колір прапора або просто для стилю)
cat << "EOF"
                                                      
                                                      
MMMM       ____     ___  ____  ____    ____      MMMM 
MM         `Mb(     )d' 6MMMMb\`MM'    `MM'        MM 
MM          YM.     ,P 6M'    ` MM      MM         MM 
MM          `Mb     d' MM       MM      MM         MM 
MM           YM.   ,P  YM.      MM      MM         MM 
MM           `Mb   d'   YMMMMb  MMMMMMMMMM         MM 
MM            YM. ,P        `Mb MM      MM         MM 
MM            `Mb d'         MM MM      MM         MM 
MM             YM,P          MM MM      MM         MM 
MM             `MM'    L    ,M9 MM      MM         MM 
MM              YP     MYMMMM9 _MM_    _MM_        MM 
MM                                                 MM 
MM                                                 MM 
MMMM                                             MMMM 
EOF
echo -e "\e[0m" # Скидаємо колір до стандартного

echo "--- Pidgotovka Vyshivki (Void-based OS) ---"
echo "Слава Україні!"
echo "-------------------------------------------------------"

# Перевірка на root (щоб не забути sudo)
if [ "$EUID" -ne 0 ]; then 
  echo "Помилка: Будь ласка, запустіть скрипт через sudo!"
  exit 1
fi

echo "--- Pidgotovka Vyshivki ---"

# Оновлення бази та самого менеджера пакунків
sudo xbps-install -Syu
sudo xbps-install -uy xbps

# Встановлення локалей (солов'їна підтримка)
sudo xbps-install -y glibc-locales
sudo sed -i 's/#uk_UA.UTF-8 UTF-8/uk_UA.UTF-8 UTF-8/' /etc/default/libc-locales
sudo xbps-reconfigure -f glibc-locales

# Налаштування мови (Англійська база + Український час)
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
echo "LC_TIME=uk_UA.UTF-8" | sudo tee -a /etc/locale.conf

echo "-------------------------------------------------------"
echo "Ласкаво прошу до збірки Vyshivka. Слава Україні!"
echo "-------------------------------------------------------"

# Лікування бази пакунків
sudo xbps-pkgdb -a

# Графіка та драйвери
echo "Встановлюємо XFCE4 та Xorg..."
sudo xbps-install -y xfce4 xfce4-plugins lightdm lightdm-gtk-greeter xorg-server xorg-video-drivers

# Мережа, Звук та Браузер 
echo "Додаємо мультимедіа та браузер..."
sudo xbps-install -y pipewire pavucontrol NetworkManager firefox

# Вмикання сервісів
echo "Активуємо сервіси..."
[ -L /var/service/lightdm ] || sudo ln -s /etc/sv/lightdm /var/service/
[ -L /var/service/NetworkManager ] || sudo ln -s /etc/sv/NetworkManager /var/service/
[ -L /var/service/dbus ] || sudo ln -s /etc/sv/dbus /var/service/

# Налаштування конфігів "з коробки"
echo "Вишиваємо конфіги..."
sudo mkdir -p /etc/skel/.config/xfce4
# Перевірка, чи папка з конфігами існує в репозиторії
if [ -d "configs/xfce4" ]; then
    sudo cp -r configs/xfce4/* /etc/skel/.config/xfce4/
else
    echo "Попередження: configs/xfce4 не знайдено, пропускаємо."
fi

echo "--- Готово! Перезавантажте систему ---"
