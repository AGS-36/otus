!#/bin/bash

# Устанавливаем nfs-utils, которые облегчат отладку
yum install nfs-utils
# включаем firewall
systemctl enable firewalld --now
# разрешаем в firewall доступ к сервисам NFS
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload
# включаем сервер NFS (для конфигурации NFSv3 over UDP он не требует дополнительной настройки /etc/nfs.conf)
systemctl enable nfs --now
# создаём и настраиваем директорию
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
# пропишем данную директорию в файле /etc/exports 
cat << EOF > /etc/exports
/srv/share 192.168.50.11/32(rw,sync,root_squash)
EOF
# экспортируем ранее созданную директорию
exportfs -r


