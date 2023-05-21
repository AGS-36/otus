```
sudo -i
[root@pam ~]# useradd otusadm && useradd otus

[root@pam ~]# echo 'Otus2022!' | passwd --stdin otusadm && echo 'Otus2022!' | passwd --stdin otus
Changing password for user otusadm.
passwd: all authentication tokens updated successfully.
Changing password for user otus.
passwd: all authentication tokens updated successfully.

[root@pam ~]# groupadd -f admin

[root@pam ~]# usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin

[root@pam ~]# cat /etc/group | grep admin
printadmin:x:997:
admin:x:1003:otusadm,root,vagrant
```
#Create script /usr/local/bin/login.sh

```
#!/bin/bash
#Первое условие: если день недели суббота или воскресенье
if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
 #Второе условие: входит ли пользователь в группу admin
 if getent group admin | grep -qw "$USER"; then
        #Если пользователь входит в группу admin, то он может подключиться
        exit 0
      else
        #Иначе ошибка (не сможет подключиться)
        exit 1
    fi
  #Если день не выходной, то подключиться может любой пользователь
  else
    exit 0
fi

```

```
[root@pam ~]# chmod +x /usr/local/bin/login.sh
[root@pam ~]# echo "" >> /etc/pam.d/sshd

(.ansible) 18 ► ssh otusadm@192.168.57.10
otusadm@192.168.57.10's password:
Last login: Sat Aug 27 12:32:13 2022 from 192.168.57.1
[otusadm@pam ~]$
(.ansible) 18 ► ssh otusadm@192.168.57.10
otusadm@192.168.57.10's password:
/usr/local/bin/login.sh failed: exit code 1
Connection closed by 192.168.57.10 port 22
```
