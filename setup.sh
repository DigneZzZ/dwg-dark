#!/bin/bash
# Получаем внешний IP-адрес
MYHOST_IP=$(hostname -I | cut -d' ' -f1)
# Обновление пакетов
printf "\e[42mОбновление пакетов...\e[0m\n"
apt update
printf "\e[42mПакеты успешно обновлены.\e[0m\n"

# Установка Git
printf "\e[42mУстановка Git...\e[0m\n"
apt install git -y
printf "\e[42mGit успешно установлен.\e[0m\n"

#  printf "Для корректной работы данной сборки необходимо освободить 53 порт. Сделать это автоматическим скриптом? Гарантий работоспособности на вашей операционной системе мы не даем!!! (Y/n) (по умолчанию - Y, можете нажать Enter): "
#read choice_resolv
#
#  if [[ $choice_resolv == "" || $choice_resolv == "Y" || $choice_resolv == "y" ]]; then
#    sh -c 'echo DNSStubListener=no >> /etc/systemd/resolved.conf' && systemctl restart systemd-resolved.service
#    systemctl stop systemd-resolved.service &&
#    rm -f /etc/resolv.conf &&
#    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf &&
#    systemctl start systemd-resolved.service
#    printf "\e[42mИмзенения в систему внесены. Но если установка контейнера завершится с ошибок, вам необходимо перезапустить сервер.\e[0m\n"
#    printf "\e[42mВыполнение скрипта будет продолжено в любом случае через 5 секунд\e[0m\n"
#    sleep 5
#  else
#    printf "Скрипт не будет запущен.\n"
#    exit 1
#  fi

# Клонирование репозитория
printf "\e[42mКлонирование репозитория dwg-dark...\e[0m\n"
git clone https://github.com/dignezzz/dwg-dark.git temp

if [ ! -d "dwg-dark" ]; then
  mkdir dwg-dark
  echo "Папка dwg-dark создана."
else
  echo "Папка dwg-dark уже существует."
fi

# копирование содержимого временной директории в целевую директорию с перезаписью существующих файлов и папок
cp -rf temp/* dwg-dark/

# удаление временной директории со всем ее содержимым
rm -rf temp
printf "\e[42mРепозиторий dwg-dark успешно клонирован до актуальной версии в репозитории.\e[0m\n"

# Переходим в папку ad-wireguard
printf "\e[42mПереходим в папку ddwg-dark...\e[0m\n"
cd dwg-dark
printf "\e[42mПерешли в папку dwg-dark\e[0m\n"

# Установка прав на файл установки
printf "\e[42mУстановка прав на файл установки...\e[0m\n"
chmod +x install.sh
printf "\e[42mПрава на файл установки выставлены.\e[0m\n"

# Запуск установки
printf "\e[42mЗапуск установки ad-wireguard...\e[0m\n"
./install.sh
printf "\e[42mУстановка ad-wireguard успешно завершена.\e[0m\n"

# Установка прав на директорию tools
printf "\e[42mУстановка прав на директорию tools...\e[0m\n"
chmod +x -R tools
printf "\e[42mПрава на директорию tools успешно установлены.\e[0m\n"

# Запуск скрипта ssh.sh
printf "\e[42mЗапуск скрипта ssh.sh для смены стандартного порта SSH...\e[0m\n"
./tools/ssh.sh
printf "\e[42mСкрипт ssh.sh успешно выполнен.\e[0m\n"

  printf "Хотите запустить скрипт wg-ru.sh для русификации и модернизации интерфейса?? (Y/n) (по умолчанию - Y, можете нажать Enter): "
read choice_ru

  if [[ $choice_ru == "" || $choice_ru == "Y" || $choice_ru == "y" ]]; then
    ./tools/wg-ru.sh
  else
    printf "Скрипт не будет запущен.\n"
  fi

# Запуск скрипта ufw.sh
printf "\e[42mЗапуск скрипта ufw.sh для установки UFW Firewall...\e[0m\n"
./tools/ufw.sh
printf "\e[42mСкрипт ufw.sh успешно выполнен.\e[0m\n"

# Переходим в папку /
printf "\e[42mПереходим в папку /root/...\e[0m\n"
cd
printf "\e[42mПерешли в папку /root/ \e[0m\n"

printf '\e[48;5;202m\e[30m ################################################################## \e[0m\n'
printf '\e[48;5;202m\e[30m Всё установлено! \e[0m\n'
printf "\e[48;5;202m\e[30m Адрес входа в веб-интерфейс WireGuard после установки: http://$MYHOST_IP:51821 \e[0m\n"
printf '\e[48;5;202m\e[30m ################################################################## \e[0m\n'
printf '\e[48;5;202m\e[30m Не забудь отдельно установить UFW-Docker, для закрытия веб-интерфейса wireguard. \e[0m\n'
printf '\e[48;5;196m\e[97m ВНИМАНИЕ! Запускать только после того как создадите для себя клиента в WireGUARD!!! \e[0m\n'
printf '\e[48;5;202m\e[30m команда для установки: ./dwg-dark/tools/ufw-docker.sh \e[0m\n'
printf '\e[48;5;202m\e[30m ################################################################## \e[0m\n'
printf '\e[48;5;202m\e[30m Если вам понравился мой скрипт, вы можете меня отблагодарить суммой на ваше усмотрение: https://yoomoney.ru/to/41001707910216 \e[0m\n'
