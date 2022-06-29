# TASK 1

```
11 ► ansible-playbook playbooks/nginx.yml

PLAY [NGINX | Install and configure NGINX] ****************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [nginx]

TASK [NGINX | Install EPEL Repo package from standart repo] ***********************************************************
ok: [nginx]

TASK [NGINX | Install NGINX package from EPEL Repo] *******************************************************************
ok: [nginx]

TASK [NGINX | Create NGINX config file from template] *****************************************************************
changed: [nginx]

RUNNING HANDLER [reload nginx] ****************************************************************************************
changed: [nginx]

PLAY RECAP ************************************************************************************************************
nginx                      : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

