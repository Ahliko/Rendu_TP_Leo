# TP2 : Appréhender l'environnement Linux

# Sommaire

- [TP2 : Appréhender l'environnement Linux](#tp2--appréhender-lenvironnement-linux)
- [I. Service SSH](#i-service-ssh)
    - [1. Analyse du service](#1-analyse-du-service)
    - [2. Modification du service](#2-modification-du-service)
- [II. Service HTTP](#ii-service-http)
    - [1. Mise en place](#1-mise-en-place)
    - [2. Analyser la conf de NGINX](#2-analyser-la-conf-de-nginx)
    - [3. Déployer un nouveau site web](#3-déployer-un-nouveau-site-web)
- [III. Your own services](#iii-your-own-services)
    - [1. Au cas où vous auriez oublié](#1-au-cas-où-vous-auriez-oublié)
    - [2. Analyse des services existants](#2-analyse-des-services-existants)
    - [3. Création de service](#3-création-de-service)

# I. Service SSH

## 1. Analyse du service

On va, dans cette première partie, analyser le service SSH qui est en cours d'exécution.

🌞 **S'assurer que le service `sshd` est démarré**

```zsh
[ahliko@TP2-linux ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-12-09 16:06:00 CET; 28min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 694 (sshd)
      Tasks: 1 (limit: 5906)
     Memory: 6.9M
        CPU: 73ms
     CGroup: /system.slice/sshd.service
             └─694 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 09 16:06:00 TP2-linux systemd[1]: Starting OpenSSH server daemon...
Dec 09 16:06:00 TP2-linux sshd[694]: Server listening on 0.0.0.0 port 22.
Dec 09 16:06:00 TP2-linux sshd[694]: Server listening on :: port 22.
Dec 09 16:06:00 TP2-linux systemd[1]: Started OpenSSH server daemon.
Dec 09 16:06:06 TP2-linux sshd[814]: Accepted password for ahliko from 10.4.1.1 port 45558 ssh2
Dec 09 16:06:06 TP2-linux sshd[814]: pam_unix(sshd:session): session opened for user ahliko(uid=1000) by (uid=0)
```


🌞 **Analyser les processus liés au service SSH**

```zsh
[ahliko@TP2-linux ~]$ ps -ef | grep ssh
root         694       1  0 16:06 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         814     694  0 16:06 ?        00:00:00 sshd: ahliko [priv]
ahliko       828     814  0 16:06 ?        00:00:00 sshd: ahliko@pts/0
ahliko       862     829  0 16:45 pts/0    00:00:00 grep --color=auto ssh
```

🌞 **Déterminer le port sur lequel écoute le service SSH**

```zsh
[ahliko@TP2-linux ~]$ sudo ss -alnpt | grep ssh
LISTEN 0      128          0.0.0.0:22      0.0.0.0:*    users:(("sshd",pid=10926,fd=3))                          
LISTEN 0      128             [::]:22         [::]:*    users:(("sshd",pid=10926,fd=4))```

🌞 **Consulter les logs du service SSH**
    
```zsh
[ahliko@TP2-linux ~]$ journalctl -xe -u sshd
Dec 09 16:06:00 TP2-linux systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 233.
Dec 09 16:06:00 TP2-linux sshd[694]: Server listening on 0.0.0.0 port 22.
Dec 09 16:06:00 TP2-linux sshd[694]: Server listening on :: port 22.
Dec 09 16:06:00 TP2-linux systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 233.
Dec 09 16:06:06 TP2-linux sshd[814]: Accepted password for ahliko from 10.4.1.1 port 45558 ssh2
Dec 09 16:06:06 TP2-linux sshd[814]: pam_unix(sshd:session): session opened for user ahliko(uid=1000) by (uid=0)
```
```zsh
[ahliko@TP2-linux ~]$ sudo tail -n 10 /var/log/secure | grep ssh
Dec  9 16:06:00 TP2-linux sshd[694]: Server listening on :: port 22.
Dec  9 16:06:06 TP2-linux sshd[814]: Accepted password for ahliko from 10.4.1.1 port 45558 ssh2
Dec  9 16:06:06 TP2-linux sshd[814]: pam_unix(sshd:session): session opened for user ahliko(uid=1000) by (uid=0)
```
## 2. Modification du service

🌞 **Identifier le fichier de configuration du serveur SSH**

```zsh
[ahliko@TP2-linux ~]$ sudo cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Fedora and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
```

🌞 **Modifier le fichier de conf**

```zsh
[ahliko@TP2-linux ~]$ echo $RANDOM
6551
```

```zsh
[ahliko@TP2-linux ~]$ sudo cat /etc/ssh/sshd_config | grep Port\ 6551
Port 6551
```

```zsh
[ahliko@TP2-linux ~]$ sudo firewall-cmd --remove-service ssh --permanent
success
[ahliko@TP2-linux ~]$ sudo firewall-cmd --add-port=6551/tcp --permanent
success
[ahliko@TP2-linux ~]$ sudo firewall-cmd --reload
success
[ahliko@TP2-linux ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client
  ports: 6551/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules:
```

🌞 **Redémarrer le service**

```zsh
[ahliko@TP2-linux ~]$ sudo systemctl restart sshd
```

🌞 **Effectuer une connexion SSH sur le nouveau port**

```zsh
ssh -p 6551 ahliko@10.4.1.11
```
✨ **Bonus : affiner la conf du serveur SSH**
```zsh
[ahliko@TP2-linux ~]$ sudo cat /etc/ssh/sshd_config
#################
#               #
#   Hardening   #
#               #
#################

ChallengeResponseAuthentication no


Port 6551


PasswordAuthentication yes
IgnoreRhosts yes
MaxAuthTries 3
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
RekeyLimit 256M
ClientAliveCountMax 2
LogLevel VERBOSE
MaxAuthTries 2
MaxSessions 3
PermitRootLogin no
UseDNS no
UsePrivilegeSeparation SANDBOX

Compression delayed
X11Forwarding no
AllowTcpForwarding no
GatewayPorts no
PermitTunnel no
TCPKeepAlive yes

#RSAAuthentication no # Deprecated
PermitEmptyPasswords no
GSSAPIAuthentication no
#PasswordAuthentication no
KerberosAuthentication no
HostbasedAuthentication no
ChallengeResponseAuthentication no
```

# II. Service HTTP

## 1. Mise en place

🌞 **Installer le serveur NGINX**

```zsh
sudo dnf install nginx -y
```

🌞 **Démarrer le service NGINX**

```zsh
sudo systemctl start nginx
```

```zsh
[ahliko@TP2-linux ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Fri 2022-12-09 17:37:27 CET; 1min 39s ago
    Process: 10966 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 10967 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 10968 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 10969 (nginx)
      Tasks: 2 (limit: 5906)
     Memory: 1.9M
        CPU: 20ms
     CGroup: /system.slice/nginx.service
             ├─10969 "nginx: master process /usr/sbin/nginx"
             └─10970 "nginx: worker process"

Dec 09 17:37:27 TP2-linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Dec 09 17:37:27 TP2-linux nginx[10967]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Dec 09 17:37:27 TP2-linux nginx[10967]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Dec 09 17:37:27 TP2-linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

🌞 **Déterminer sur quel port tourne NGINX**

```zsh
[ahliko@TP2-linux ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=10970,fd=6),("nginx",pid=10969,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=10970,fd=7),("nginx",pid=10969,fd=7))
```

```zsh
[ahliko@TP2-linux ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
[ahliko@TP2-linux ~]$ sudo firewall-cmd --reload
```
🌞 **Déterminer les processus liés à l'exécution de NGINX**

```zsh
[ahliko@TP2-linux ~]$ ps -ef | grep nginx
root       10969       1  0 17:37 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      10970   10969  0 17:37 ?        00:00:00 nginx: worker process
ahliko     11063    1040  0 18:06 pts/0    00:00:00 grep --color=auto nginx
```

🌞 **Euh wait**

```zsh
[ahliko@ahliko-pc ~]$ curl http://10.4.1.11:80 --silent | head -n 7
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```
## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

```zsh
[ahliko@TP2-linux nginx]$ ls -al /etc/nginx
total 84
drwxr-xr-x.  4 root root 4096 Dec  9 17:26 .
drwxr-xr-x. 78 root root 8192 Dec 10 10:22 ..
drwxr-xr-x.  2 root root    6 Oct 31 16:37 conf.d
drwxr-xr-x.  2 root root    6 Oct 31 16:37 default.d
-rw-r--r--.  1 root root 1077 Oct 31 16:37 fastcgi.conf
-rw-r--r--.  1 root root 1077 Oct 31 16:37 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 Oct 31 16:37 fastcgi_params
-rw-r--r--.  1 root root 1007 Oct 31 16:37 fastcgi_params.default
-rw-r--r--.  1 root root 2837 Oct 31 16:37 koi-utf
-rw-r--r--.  1 root root 2223 Oct 31 16:37 koi-win
-rw-r--r--.  1 root root 5231 Oct 31 16:37 mime.types
-rw-r--r--.  1 root root 5231 Oct 31 16:37 mime.types.default
-rw-r--r--.  1 root root 2334 Oct 31 16:37 nginx.conf
-rw-r--r--.  1 root root 2656 Oct 31 16:37 nginx.conf.default
-rw-r--r--.  1 root root  636 Oct 31 16:37 scgi_params
-rw-r--r--.  1 root root  636 Oct 31 16:37 scgi_params.default
-rw-r--r--.  1 root root  664 Oct 31 16:37 uwsgi_params
-rw-r--r--.  1 root root  664 Oct 31 16:37 uwsgi_params.default
-rw-r--r--.  1 root root 3610 Oct 31 16:37 win-utf
```

🌞 **Trouver dans le fichier de conf**

```zsh
[ahliko@TP2-linux nginx]$ cat nginx.conf | grep "server {" -A 23
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

```zsh
[ahliko@TP2-linux nginx]$ cat nginx.conf | grep include | grep .conf
include /usr/share/nginx/modules/*.conf;
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**

```zsh
[ahliko@TP2-linux var]$ sudo mkdir www
[ahliko@TP2-linux www]$ sudo mkdir tp2_linux
[ahliko@TP2-linux tp2_linux]$ sudo cat index.html
<h1>MEOW mon premier serveur web</h1>
```

🌞 **Adapter la conf NGINX**

```zsh
[ahliko@TP2-linux ~]$ cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;


# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```

```zsh
sudo systemctl restart nginx
```


```zsh
[ahliko@TP2-linux ~]$ echo $RANDOM
27834
```

```zsh
[ahliko@TP2-linux ~]$ sudo cat /etc/nginx/conf.d/server.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 27834;

  root /var/www/tp2_linux;
}
```

```zsh
[ahliko@TP2-linux ~]$ sudo sudo firewall-cmd --remove-port=80/tcp --permanent
success
[ahliko@TP2-linux ~]$ sudo sudo firewall-cmd --add-port=27834/tcp --permanent
success
[ahliko@TP2-linux ~]$ sudo firewall-cmd --reload
success
[ahliko@TP2-linux ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client
  ports: 6551/tcp 27834/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

🌞 **Visitez votre super site web**

```zsh
[ahliko@ahliko-pc ~]$ curl 10.4.1.11:27834
<h1>MEOW mon premier serveur web</h1>
```

# III. Your own services

## 1. Au cas où vous auriez oublié

## 2. Analyse des services existants

🌞 **Afficher le fichier de service SSH**

```zsh
[ahliko@TP2-linux ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS
```
🌞 **Afficher le fichier de service NGINX**

```zsh
[ahliko@TP2-linux ~]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

## 3. Création de service

![Create service](./pics/create_service.png)

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

```zsh
[ahliko@TP2-linux ~]$ echo $RANDOM
139
[ahliko@TP2-linux ~]$ cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 139
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

```zsh
[ahliko@TP2-linux ~]$ sudo systemctl daemon-reload
```

🌞 **Démarrer notre service de ouf**

```zsh
[ahliko@TP2-linux ~]$ sudo systemctl start tp2_nc
[ahliko@TP2-linux ~]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Sat 2022-12-10 12:16:20 CET; 38s ago
   Main PID: 1942 (nc)
      Tasks: 1 (limit: 5906)
     Memory: 788.0K
        CPU: 3ms
     CGroup: /system.slice/tp2_nc.service
             └─1942 /usr/bin/nc -l 139

Dec 10 12:16:20 TP2-linux systemd[1]: Started Super netcat tout fou.
```

🌞 **Vérifier que ça fonctionne**

- vérifier que le service tourne avec un `systemctl status <SERVICE>`
- vérifier que `nc` écoute bien derrière un port avec un `ss`
    - vous filtrerez avec un `| grep` la sortie de la commande pour n'afficher que les lignes intéressantes
- vérifer que juste ça marche en vous connectant au service depuis une autre VM
    - allumez une autre VM vite fait et vous tapez une commande `nc` pour vous connecter à la première

> **Normalement**, dans ce TP, vous vous connectez depuis votre PC avec un `nc` vers la VM, mais bon. Vos supers OS Windows/MacOS chient un peu sur les conventions de réseau, et ça marche pas super super en utilisant un `nc` directement sur votre machine. Donc voilà, allons au plus simple : allumez vite fait une deuxième qui servira de client pour tester la connexion à votre service `tp2_nc`.

➜ Si vous vous connectez avec le client, que vous envoyez éventuellement des messages, et que vous quittez `nc` avec un CTRL+C, alors vous pourrez constater que le service s'est stoppé

- bah oui, c'est le comportement de `nc` ça !
- le client se connecte, et quand il se tire, ça ferme `nc` côté serveur aussi
- faut le relancer si vous voulez retester !

🌞 **Les logs de votre service**

- mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
- `sudo journalctl -xe -u tp2_nc` pour visualiser les logs de votre service
- `sudo journalctl -xe -u tp2_nc -f ` pour visualiser **en temps réel** les logs de votre service
    - `-f` comme follow (on "suit" l'arrivée des logs en temps réel)
- dans le compte-rendu je veux
    - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
    - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
    - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service

🌞 **Affiner la définition du service**

- faire en sorte que le service redémarre automatiquement s'il se termine
    - comme ça, quand un client se co, puis se tire, le service se relancera tout seul
    - ajoutez `Restart=always` dans la section `[Service]` de votre service
    - n'oubliez pas d'indiquer au système que vous avez modifié les fichiers de service :)