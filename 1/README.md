# **Kernel update**
```
manual_kernel_update ► vagrant up
Bringing machine 'kernel-update' up with 'virtualbox' provider...
==> kernel-update: Importing base box 'centos/7'...
==> kernel-update: Matching MAC address for NAT networking...
==> kernel-update: Checking if box 'centos/7' version '2004.01' is up to date...
manual_kernel_update ► vagrant ssh
[vagrant@kernel-update ~]$ uname -r
3.10.0-1127.el7.x86_64
[vagrant@kernel-update ~]$ sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
Loaded plugins: fastestmirror
elrepo-release-7.0-3.el7.elrepo.noarch.rpm                                                      | 8.5 kB  00:00:00
Examining /var/tmp/yum-root-TX5YuK/elrepo-release-7.0-3.el7.elrepo.noarch.rpm: elrepo-release-7.0-3.el7.elrepo.noarch
Marking /var/tmp/yum-root-TX5YuK/elrepo-release-7.0-3.el7.elrepo.noarch.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package elrepo-release.noarch 0:7.0-3.el7.elrepo will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=======================================================================================================================
 Package                Arch           Version                   Repository                                       Size
=======================================================================================================================
Installing:
 elrepo-release         noarch         7.0-3.el7.elrepo          /elrepo-release-7.0-3.el7.elrepo.noarch         5.2 k

Transaction Summary
=======================================================================================================================
Install  1 Package

Total size: 5.2 k
Installed size: 5.2 k
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : elrepo-release-7.0-3.el7.elrepo.noarch                                                              1/1
  Verifying  : elrepo-release-7.0-3.el7.elrepo.noarch                                                              1/1

Installed:
  elrepo-release.noarch 0:7.0-3.el7.elrepo

Complete!
[vagrant@kernel-update ~]$ sudo yum --enablerepo elrepo-kernel install kernel-ml -y
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: centos.mirror.far.fi
 * elrepo: elrepo.org
 * elrepo-kernel: elrepo.org
 * extras: centos.mirror.far.fi
 * updates: centos.mirror.far.fi
base                                                                                            | 3.6 kB  00:00:00
elrepo                                                                                          | 3.0 kB  00:00:00
elrepo-kernel                                                                                   | 3.0 kB  00:00:00
extras                                                                                          | 2.9 kB  00:00:00
updates                                                                                         | 2.9 kB  00:00:00
(1/6): base/7/x86_64/group_gz                                                                   | 153 kB  00:00:01
(2/6): extras/7/x86_64/primary_db                                                               | 246 kB  00:00:03
(3/6): elrepo/primary_db                                                                        | 480 kB  00:00:10
(4/6): base/7/x86_64/primary_db                                                                 | 6.1 MB  00:00:15
(5/6): elrepo-kernel/primary_db                                                                 | 2.1 MB  00:00:20
(6/6): updates/7/x86_64/primary_db                                                              |  15 MB  00:00:34
Resolving Dependencies
--> Running transaction check
---> Package kernel-ml.x86_64 0:5.17.6-1.el7.elrepo will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=======================================================================================================================
 Package                  Arch                  Version                             Repository                    Size
=======================================================================================================================
Installing:
 kernel-ml                x86_64                5.17.6-1.el7.elrepo                 elrepo-kernel                 56 M

Transaction Summary
=======================================================================================================================
Install  1 Package

Total download size: 56 M
Installed size: 255 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/elrepo-kernel/packages/kernel-ml-5.17.6-1.el7.elrepo.x86_64.rpm: Header V4 DSA/SHA256 Signature, key ID baadae52: NOKEY
Public key for kernel-ml-5.17.6-1.el7.elrepo.x86_64.rpm is not installed
kernel-ml-5.17.6-1.el7.elrepo.x86_64.rpm                                                        |  56 MB  00:01:42
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
Importing GPG key 0xBAADAE52:
 Userid     : "elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>"
 Fingerprint: 96c0 104f 6315 4731 1e0b b1ae 309b c305 baad ae52
 Package    : elrepo-release-7.0-3.el7.elrepo.noarch (@/elrepo-release-7.0-3.el7.elrepo.noarch)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : kernel-ml-5.17.6-1.el7.elrepo.x86_64                                                                1/1
  Verifying  : kernel-ml-5.17.6-1.el7.elrepo.x86_64                                                                1/1

Installed:
  kernel-ml.x86_64 0:5.17.6-1.el7.elrepo

Complete!
[vagrant@kernel-update ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.17.6-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.17.6-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-1127.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1127.el7.x86_64.img
done
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
manual_kernel_update ► vagrant ssh
Last login: Mon May  9 22:49:12 2022 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
5.17.6-1.el7.elrepo.x86_64
[vagrant@kernel-update ~]$
```

# **packer build**
```
...

    centos-7.7 (vagrant): Compressing: packer-centos-vm.mf
Build 'centos-7.7' finished after 1 hour 4 minutes.

==> Wait completed after 1 hour 4 minutes

==> Builds finished. The artifacts of successful builds are:
--> centos-7.7: 'virtualbox' provider box: centos-7.7.1908-kernel-5-x86_64-Minimal.box

packer ► ls
centos-7.7.1908-kernel-5-x86_64-Minimal.box  centos.json  http  new.json  scripts
```

# **vagrant init (тестирование)**
```
packer ► vagrant box add --name centos-7-5 centos-7.7.1908-kernel-5-x86_64-Minimal.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'centos-7-5' (v0) for provider:
    box: Unpacking necessary files from: file:///home/rod/Linux/homework/manual_kernel_update/packer/centos-7.7.1908-kernel-5-x86_64-Minimal.box
==> box: Successfully added box 'centos-7-5' (v0) for 'virtualbox'!
packer ► vagrant box list
centos-7-5            (virtualbox, 0)
bento/ubuntu-20.04 (virtualbox, 202012.23.0)
centos-7-5         (virtualbox, 0)
centos/7           (virtualbox, 2004.01)
bash: syntax error near unexpected token `virtualbox,'
packer ► vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'centos-7-5'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: packer_default_1652300641000_77282
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    
packer ► vagrant ssh
Last login: Wed May 11 20:17:06 2022 from 10.0.2.2
[vagrant@localhost ~]$ 
[vagrant@localhost ~]$ uname -r
5.17.6-1.el7.elrepo.x86_64
```

# **Vagrant cloud**
```
Releasing box...
Complete! Published ags36/centos-7-5
Box:              ags36/centos-7-5
Description:      
Private:          yes
Created:          2022-05-11T20:26:41.663Z
Updated:          2022-05-11T20:26:45.499Z
Current Version:  N/A
Versions:         1.0
Downloads:        0
```

- **Vagrant Cloud** - https://app.vagrantup.com/ags36/boxes/centos-7-5

# TASK*
```
manual_kernel_update ► vagrant ssh
[vagrant@kernel-update ~]$ uname -r
3.10.0-1127.el7.x86_64
[vagrant@kernel-update ~]$ sudo yum group install "Development Tools"
[vagrant@kernel-update ~]$ sudo yum install devtoolset-7 ; scl enable devtoolset-7 bash
[vagrant@kernel-update ~]$ sudo yum install openssl-devel 
[vagrant@kernel-update ~]$ wget https://www.kernel.org/
[vagrant@kernel-update ~]$ tar xvf linux*
[vagrant@kernel-update linux-5.17.6]$ cp /boot/config-3.10.0-1127.el7.x86_64 .config
[vagrant@kernel-update linux-5.17.6]$ make oldconfig
.config:697:warning: symbol value 'm' invalid for CPU_FREQ_STAT
.config:941:warning: symbol value 'm' invalid for NF_CT_PROTO_GRE
.config:969:warning: symbol value 'm' invalid for NF_NAT_REDIRECT
.config:972:warning: symbol value 'm' invalid for NF_TABLES_INET
.config:1139:warning: symbol value 'm' invalid for NF_TABLES_IPV4
.config:1143:warning: symbol value 'm' invalid for NF_TABLES_ARP
.config:1184:warning: symbol value 'm' invalid for NF_TABLES_IPV6
.config:1559:warning: symbol value 'm' invalid for NET_DEVLINK
.config:2719:warning: symbol value 'm' invalid for ISDN_CAPI
.config:3664:warning: symbol value 'm' invalid for LIRC
*
* Restart config...
*
*
* General setup
*
Compile also drivers which will not load (COMPILE_TEST) [N/y/?] (NEW) 
[vagrant@kernel-update linux-5.17.6]$ make
[vagrant@kernel-update linux-5.17.6]$ make modules
[vagrant@kernel-update linux-5.17.6]$ sudo make modules_install
[vagrant@kernel-update linux-5.17.6]$ sudo make install
[vagrant@kernel-update linux-5.17.6]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.17.6
Found initrd image: /boot/initramfs-5.17.6.img
Found linux image: /boot/vmlinuz-3.10.0-1127.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1127.el7.x86_64.img
done
[vagrant@kernel-update linux-5.17.6]$ sudo grub2-set-default 0
[vagrant@kernel-update linux-5.17.6]$ sudo reboot
manual_kernel_update ► vagrant ssh
Last login: Thu May 12 08:56:26 2022 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
5.17.6
```
# TASK**
```
заменил config.vm.synced_folder ".", "/vagrant", disabled: true на
config.vm.synced_folder ".", "/vagrant",  :mount_options => ["dmode=755,fmode=755"]

manual_kernel_update ► vagrant ssh
Last login: Thu May 12 16:56:20 2022 from 10.0.2.2
[vagrant@kernel-update ~]$ cd /vagrant/
[vagrant@kernel-update vagrant]$ ls
manual  packer  Vagrantfile
[vagrant@kernel-update vagrant]$ 
```
