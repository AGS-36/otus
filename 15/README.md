```
[root@log ~]# cat /var/log/rsyslog/web/nginx_error.log
Apr 28 16:39:09 web nginx_error: 2023/04/28 16:39:09 [error] 1134#1134: *3 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.50.1, server: _, request: "GET /favicon.ico HTTP/1.1", host: "192.168.50.10", referrer: "http://192.168.50.10/"
[root@log ~]# cat /var/log/rsyslog/web/nginx_access.log
Apr 28 16:39:09 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:09 +0300] "GET /favicon.ico HTTP/1.1" 404 3650 "http://192.168.50.10/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:34 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:34 +0300] "GET / HTTP/1.1" 200 4833 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:34 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:34 +0300] "GET /favicon.ico HTTP/1.1" 404 3650 "http://192.168.50.10/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:35 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:35 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:36 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:36 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:36 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:36 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:36 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:36 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
Apr 28 16:39:37 web nginx_access: 192.168.50.1 - - [28/Apr/2023:16:39:37 +0300] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"
```
4.
```
[root@web ~]# ausearch -f /etc/nginx/nginx.conf
<no matches>
[root@web ~]# vim /etc/nginx/nginx.conf
[root@web ~]# ausearch -f /etc/nginx/nginx.conf
----
time->Fri Apr 28 16:50:31 2023
type=CONFIG_CHANGE msg=audit(1682689831.828:113): auid=1000 ses=1 op=updated_rules path="/etc/nginx/nginx.conf" key="nginx_conf" list=4 res=1
----
time->Fri Apr 28 16:50:31 2023
type=PROCTITLE msg=audit(1682689831.828:114): proctitle=76696D002F6574632F6E67696E782F6E67696E782E636F6E66
type=PATH msg=audit(1682689831.828:114): item=3 name="/etc/nginx/nginx.conf~" inode=4999881 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1682689831.828:114): item=2 name="/etc/nginx/nginx.conf" inode=4999881 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=DELETE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1682689831.828:114): item=1 name="/etc/nginx/" inode=85 dev=fd:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1682689831.828:114): item=0 name="/etc/nginx/" inode=85 dev=fd:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1682689831.828:114):  cwd="/root"
type=SYSCALL msg=audit(1682689831.828:114): arch=c000003e syscall=82 success=yes exit=0 a0=17d87c0 a1=19b3630 a2=fffffffffffffe80 a3=7fff8511dc60 items=4 ppid=976 pid=1255 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="vim" exe="/usr/bin/vim" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"
----
time->Fri Apr 28 16:50:31 2023
type=CONFIG_CHANGE msg=audit(1682689831.828:115): auid=1000 ses=1 op=updated_rules path="/etc/nginx/nginx.conf" key="nginx_conf" list=4 res=1
----
time->Fri Apr 28 16:50:31 2023
type=PROCTITLE msg=audit(1682689831.828:116): proctitle=76696D002F6574632F6E67696E782F6E67696E782E636F6E66
type=PATH msg=audit(1682689831.828:116): item=1 name="/etc/nginx/nginx.conf" inode=15391 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:httpd_config_t:s0 objtype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1682689831.828:116): item=0 name="/etc/nginx/" inode=85 dev=fd:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1682689831.828:116):  cwd="/root"
type=SYSCALL msg=audit(1682689831.828:116): arch=c000003e syscall=2 success=yes exit=3 a0=17d87c0 a1=241 a2=1a4 a3=0 items=2 ppid=976 pid=1255 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="vim" exe="/usr/bin/vim" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"
----
time->Fri Apr 28 16:50:31 2023
type=PROCTITLE msg=audit(1682689831.842:117): proctitle=76696D002F6574632F6E67696E782F6E67696E782E636F6E66
type=PATH msg=audit(1682689831.842:117): item=0 name="/etc/nginx/nginx.conf" inode=15391 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:httpd_config_t:s0 objtype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1682689831.842:117):  cwd="/root"
type=SYSCALL msg=audit(1682689831.842:117): arch=c000003e syscall=188 success=yes exit=0 a0=17d87c0 a1=7fc56403bf6a a2=19b2770 a3=24 items=1 ppid=976 pid=1255 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="vim" exe="/usr/bin/vim" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"
----
time->Fri Apr 28 16:50:31 2023
type=PROCTITLE msg=audit(1682689831.842:118): proctitle=76696D002F6574632F6E67696E782F6E67696E782E636F6E66
type=PATH msg=audit(1682689831.842:118): item=0 name="/etc/nginx/nginx.conf" inode=15391 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1682689831.842:118):  cwd="/root"
type=SYSCALL msg=audit(1682689831.842:118): arch=c000003e syscall=90 success=yes exit=0 a0=17d87c0 a1=81a4 a2=7fff8511f2b0 a3=24 items=1 ppid=976 pid=1255 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="vim" exe="/usr/bin/vim" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"
----
time->Fri Apr 28 16:50:31 2023
type=PROCTITLE msg=audit(1682689831.842:119): proctitle=76696D002F6574632F6E67696E782F6E67696E782E636F6E66
type=PATH msg=audit(1682689831.842:119): item=0 name="/etc/nginx/nginx.conf" inode=15391 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1682689831.842:119):  cwd="/root"
type=SYSCALL msg=audit(1682689831.842:119): arch=c000003e syscall=188 success=yes exit=0 a0=17d87c0 a1=7fc563bf1e2f a2=19cac00 a3=1c items=1 ppid=976 pid=1255 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="vim" exe="/usr/bin/vim" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"

[root@log ~]# grep web /var/log/audit/audit.log
node=web type=DAEMON_START msg=audit(1682690151.869:4366): op=start ver=2.8.5 format=raw kernel=3.10.0-1127.el7.x86_64 auid=4294967295 pid=1335 uid=0 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=success
node=web type=CONFIG_CHANGE msg=audit(1682690152.029:125): auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 op=remove_rule key="nginx_conf" list=4 res=1
node=web type=CONFIG_CHANGE msg=audit(1682690152.029:126): auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 op=remove_rule key="nginx_conf" list=4 res=1
node=web type=CONFIG_CHANGE msg=audit(1682690152.029:127): audit_backlog_limit=8192 old=8192 auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 res=1
node=web type=CONFIG_CHANGE msg=audit(1682690152.030:128): audit_failure=1 old=1 auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 res=1
node=web type=CONFIG_CHANGE msg=audit(1682690152.030:129): auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 op=add_rule key="nginx_conf" list=4 res=1
node=web type=CONFIG_CHANGE msg=audit(1682690152.030:130): auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 op=add_rule key="nginx_conf" list=4 res=1
node=web type=SERVICE_START msg=audit(1682690152.039:131): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=auditd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
node=web type=SYSCALL msg=audit(1682690275.936:132): arch=c000003e syscall=268 success=yes exit=0 a0=ffffffffffffff9c a1=d010f0 a2=1ed a3=7ffeb50ab0a0 items=1 ppid=976 pid=1359 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="chmod" exe="/usr/bin/chmod" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_conf"
node=web type=CWD msg=audit(1682690275.936:132):  cwd="/root"
node=web type=PATH msg=audit(1682690275.936:132): item=0 name="/etc/nginx/nginx.conf" inode=15391 dev=fd:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
node=web type=PROCTITLE msg=audit(1682690275.936:132): proctitle=63686D6F64002B78002F6574632F6E67696E782F6E67696E782E636F6E66


```
