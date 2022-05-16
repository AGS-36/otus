# **Сборка R5**
```
# Смотрим имеющиеся разделы
[vagrant@otuslinux ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  250M  0 disk 
sdb      8:16   0  250M  0 disk 
sdc      8:32   0  250M  0 disk 
sdd      8:48   0  250M  0 disk 
sde      8:64   0   40G  0 disk 
└─sde1   8:65   0   40G  0 part /

# Создаем разделы
[vagrant@otuslinux ~]$ fdisk /dev/sda
fdisk: cannot open /dev/sda: Permission denied
[vagrant@otuslinux ~]$ sudo fdisk /dev/sda 
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x23b48071.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 
First sector (2048-511999, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-511999, default 511999): 
Using default value 511999
Partition 1 of type Linux and of size 249 MiB is set

Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): fd
Changed type of partition 'Linux' to 'Linux raid autodetect'

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

# Эту процедуру повторяем для sdb, sdc
...
...
...

# Создаем RAID5-массив

[vagrant@otuslinux ~]$ sudo mdadm --create --verbose /dev/md0 --level=5  --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1

mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: size set to 252928K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

# Проверяем правильность сборки
[vagrant@otuslinux ~]$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc1[3] sdb1[1] sda1[0]
      505856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

# Создаем  файловую системy поверх RAID-массива 
[vagrant@otuslinux ~]$ sudo mkfs.ext3 /dev/md0
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=512 blocks, Stripe width=1024 blocks
126480 inodes, 505856 blocks
25292 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67633152
62 block groups
8192 blocks per group, 8192 fragments per group
2040 inodes per group
Superblock backups stored on blocks:
	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

# Создаем точку монтирования для RAID-массива
[vagrant@otuslinux ~]$ sudo mkdir /raid

# Создание конфигурационного файла mdadm.conf 
[root@otuslinux raid]# mkdir /etc/mdadm
[root@otuslinux raid]# echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
[root@otuslinux raid]# mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
[root@otuslinux raid]# cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid5 num-devices=3 metadata=1.2 name=otuslinux:0 UUID=84470103:1a7e1b36:8339db5d:ea9f15a2

# Добавим изменения в fstab
/dev/md0      /raid     ext3    defaults    1 2

# Монтируем
[vagrant@otuslinux ~]$ sudo mount -a

# Проверка состояния RAID-массива 
[root@otuslinux raid]# echo 'check' >/sys/block/md0/md/sync_action
[root@otuslinux raid]# cat /sys/block/md0/md/mismatch_cnt
0
```

## Ломаем RAID5-массив
```
[root@otuslinux raid]# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
[root@otuslinux raid]# mdadm /dev/md0 -r /dev/sdb1
mdadm: hot removed /dev/sdb1 from /dev/md0
[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdd1[3] sdc1[1]
      505856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
      
unused devices: <none>
```

## Воcстанавливаем RAID5-массив
```
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -a /dev/sde1
mdadm: added /dev/sde1
[vagrant@otuslinux ~]$ sudo mdadm --assemble /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1 
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
mdadm: /dev/sde1 is busy - skipping
[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sde1[4] sdd1[3] sdc1[1]
      505856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      
unused devices: <none>
```

# **Сборка R0**

## Повторяем процедуру с созданием разделов
## Создаем RAID0-массив
```
[root@otuslinux vagrant]# sudo mdadm --create /dev/md0 --level=0 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
## Создаем файловую систему поверх рейд массива
```
[root@otuslinux vagrant]# sudo mkfs -t ext4 /dev/md0
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
47424 inodes, 189696 blocks
9484 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=195035136
6 block groups
32768 blocks per group, 32768 fragments per group
7904 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```
## Монтируем
```
[root@otuslinux vagrant]# sudo mount /dev/md0 /mnt
```
## Создаем конфигурацию RAID-массива
```
[root@otuslinux vagrant]# mdadm --detail --scan --verbose | sudo tee -a /etc/mdadm/mdadm.conf
tee: /etc/mdadm/mdadm.conf: No such file or directory
ARRAY /dev/md0 level=raid0 num-devices=3 metadata=1.2 name=otuslinux:0 UUID=929c3eef:9f602dd4:2f8bef28:ce2fafe9
   devices=/dev/sdb1,/dev/sdc1,/dev/sdd1
```
## Добавляем сведения в fstab /dev/md0 /mnt/ ext4 defaults 0 0


# **Создание R10**

```
[vagrant@otuslinux ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0  250M  0 disk
sdc      8:32   0  250M  0 disk
sdd      8:48   0  250M  0 disk
sde      8:64   0  250M  0 disk
sdf      8:80   0  250M  0 disk
sdg      8:96   0  250M  0 disk

[vagrant@otuslinux ~]$ sudo mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sde /dev/sdb /dev/sdc /dev/sdd
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon May 16 18:21:50 2022
        Raid Level : raid10
        Array Size : 507904 (496.00 MiB 520.09 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Mon May 16 18:21:53 2022
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : a2f330b0:f112409a:02ce2d9b:3bc946b9
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde

```

## Ломаем RAID-массив
```
[vagrant@otuslinux ~]$sudo mdadm /dev/md0 --fail /dev/sdc
mdadm: set /dev/sdc faulty in /dev/md0
[vagrant@otuslinux ~]$ cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sde[3] sdd[2] sdc[1](F) sdb[0]
      507904 blocks super 1.2 512K chunks 2 near-copies [4/3] [U_UU]

[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -r /dev/sdc
mdadm: hot removed /dev/sdc from /dev/md0
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -f /dev/sdd
mdadm: set /dev/sdd faulty in /dev/md0
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -r /dev/sdd
mdadm: hot removed /dev/sdd from /dev/md0
[vagrant@otuslinux ~]$ cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sde[3] sdb[0]
      507904 blocks super 1.2 512K chunks 2 near-copies [4/2] [U__U]

unused devices: <none>
```

## Восстановливаем RAID10-массив
```
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -a /dev/sdf
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 -a /dev/sdg
[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdf[4] sde[3] sdb[0]
      507904 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      
unused devices: <none>
```

## Создание конфигурационного файла mdadm.conf 
```
[root@otuslinux raid]# mkdir /etc/mdadm
[root@otuslinux raid]# echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
[root@otuslinux raid]# mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
[root@otuslinux raid]# cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid5 num-devices=3 metadata=1.2 name=otuslinux:0 UUID=84470103:1a7e1b36:8339db5d:ea9f15a2

## Добавим изменения в fstab
/dev/md0      /raid     ext3    defaults    1 2
```

# **Bash script**
```
#!/bin/bash
su
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
```

# ***Создаю GPT раздел и пять партиций***
```
[root@otuslinux vagrant]# parted -s /dev/md0 mklabel gpt
[root@otuslinux vagrant]# parted /dev/md0 mkpart primary ext4 0% 10%
Information: You may need to update /etc/fstab.

[root@otuslinux vagrant]# parted /dev/md0 mkpart primary ext4 10% 20%
Information: You may need to update /etc/fstab.

[root@otuslinux vagrant]# parted /dev/md0 mkpart primary ext4 20% 25%
Information: You may need to update /etc/fstab.

[root@otuslinux vagrant]# parted /dev/md0 mkpart primary ext4 25% 50%
Information: You may need to update /etc/fstab.

[root@otuslinux vagrant]# parted /dev/md0 mkpart primary ext4 50% 100%
Information: You may need to update /etc/fstab.

[root@otuslinux vagrant]# lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT
sda         8:0    0  250M  0 disk
└─md0       9:0    0  496M  0 raid10
  ├─md0p1 259:0    0   49M  0 md
  ├─md0p2 259:1    0   49M  0 md
  ├─md0p3 259:2    0   25M  0 md
  ├─md0p4 259:3    0  124M  0 md
  └─md0p5 259:4    0  247M  0 md
sdb         8:16   0  250M  0 disk
sdc         8:32   0  250M  0 disk
sdd         8:48   0  250M  0 disk
└─md0       9:0    0  496M  0 raid10
  ├─md0p1 259:0    0   49M  0 md
  ├─md0p2 259:1    0   49M  0 md
  ├─md0p3 259:2    0   25M  0 md
  ├─md0p4 259:3    0  124M  0 md
  └─md0p5 259:4    0  247M  0 md
sde         8:64   0  250M  0 disk
└─md0       9:0    0  496M  0 raid10
  ├─md0p1 259:0    0   49M  0 md
  ├─md0p2 259:1    0   49M  0 md
  ├─md0p3 259:2    0   25M  0 md
  ├─md0p4 259:3    0  124M  0 md
  └─md0p5 259:4    0  247M  0 md
sdf         8:80   0  250M  0 disk
└─md0       9:0    0  496M  0 raid10
  ├─md0p1 259:0    0   49M  0 md
  ├─md0p2 259:1    0   49M  0 md
  ├─md0p3 259:2    0   25M  0 md
  ├─md0p4 259:3    0  124M  0 md
  └─md0p5 259:4    0  247M  0 md
sdg         8:96   0   40G  0 disk
└─sdg1      8:97   0   40G  0 part   /
```
