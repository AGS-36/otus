!#/bin/bash

# устанавливаем вспомогательные утилиты
yum install nfs-utils
# включаем firewal
systemctl enable firewalld --now
# добавляем в /etc/fstab строку
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
# перезапускаем демон
systemctl daemon-reload
systemctl restart remote-fs.target


