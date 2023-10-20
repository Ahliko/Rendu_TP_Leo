# TP2 : Environnement virtuel

- [TP2 : Environnement virtuel](#tp2--environnement-virtuel)
- [I. Topologie réseau](#i-topologie-réseau)
    - [Compte-rendu](#compte-rendu)
- [II. Interlude accès internet](#ii-interlude-accès-internet)
- [III. Services réseau](#iii-services-réseau)
    - [1. DHCP](#1-dhcp)
    - [2. Web web web](#2-web-web-web)

# I. Topologie réseau

## Compte-rendu

☀️ Sur **`node1.lan1.tp2`**

- afficher ses cartes réseau

```bash
[ahliko@node1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:7b:9a:e1 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.11/24 brd 10.1.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7b:9ae1/64 scope link 
       valid_lft forever preferred_lft forever
```

- afficher sa table de routage

```bash
[ahliko@node1 ~]$ ip r s
10.1.1.0/24 dev enp0s8 proto kernel scope link src 10.1.1.11 metric 100 
10.1.2.0/24 via 10.1.1.254 dev enp0s8 
```
- prouvez qu'il peut joindre `node2.lan2.tp2`

```bash
[ahliko@node1 ~]$ ping node2.lan2.tp2
PING node2.lan2.tp2 (10.1.2.12) 56(84) bytes of data.
64 bytes from node2.lan2.tp2 (10.1.2.12): icmp_seq=1 ttl=63 time=0.607 ms
64 bytes from node2.lan2.tp2 (10.1.2.12): icmp_seq=2 ttl=63 time=0.468 ms
^C
--- node2.lan2.tp2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1067ms
rtt min/avg/max/mdev = 0.468/0.537/0.607/0.069 ms
```

- prouvez avec un `traceroute` que le paquet passe bien par `router.tp2`

```bash
[ahliko@node1 ~]$ traceroute node2.lan2.tp2
traceroute to node2.lan2.tp2 (10.1.2.12), 30 hops max, 60 byte packets
 1  10.1.1.254 (10.1.1.254)  0.297 ms  0.272 ms  0.264 ms
 2  node2.lan2.tp2 (10.1.2.12)  0.629 ms !X  0.616 ms !X  0.592 ms !X
```

# II. Interlude accès internet


☀️ **Sur `router.tp2`**

- prouvez que vous avez un accès internet (ping d'une IP publique)

```bash
[ahliko@router ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=63 time=65.8 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=63 time=59.8 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1006ms
rtt min/avg/max/mdev = 59.757/62.774/65.792/3.017 ms
```

- prouvez que vous pouvez résoudre des noms publics (ping d'un nom de domaine public)

```bash
[ahliko@router ~]$ ping google.com
PING google.com (142.250.74.238) 56(84) bytes of data.
64 bytes from par10s40-in-f14.1e100.net (142.250.74.238): icmp_seq=1 ttl=63 time=39.4 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 1 received, 50% packet loss, time 1001ms
rtt min/avg/max/mdev = 39.410/39.410/39.410/0.000 ms
```


☀️ **Accès internet LAN1 et LAN2**

- ajoutez une route par défaut sur les deux machines du LAN1
```bash
[ahliko@node1 ~]$ sudo ip r a default via 10.1.1.254
[ahliko@node2 ~]$ sudo ip r a default via 10.1.1.254
```

- ajoutez une route par défaut sur les deux machines du LAN2

```bash
[ahliko@node1 ~]$ sudo ip r a default via 10.1.2.254
[ahliko@node2 ~]$ sudo ip r a default via 10.1.2.254
```

- configurez l'adresse d'un serveur DNS que vos machines peuvent utiliser pour résoudre des noms
- dans le compte-rendu, mettez-moi que la conf des points précédents sur `node2.lan1.tp2`

```bash
[ahliko@node2 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
NAME=enp0s8
DEVICE=enp0s8

BOOTPROTO=static
ONBOOT=yes

IPADDR=10.1.1.12
NETMASK=255.255.255.0

GATEWAY=10.1.1.254
DNS1=1.1.1.1
```

- prouvez que `node2.lan1.tp2` a un accès internet :
    - il peut ping une IP publique
    - il peut ping un nom de domaine public
```bash
[ahliko@node2 ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=42.7 ms
^C
--- 1.1.1.1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 42.749/42.749/42.749/0.000 ms
[ahliko@node2 ~]$ ping google.com
PING google.com (216.58.214.174) 56(84) bytes of data.
64 bytes from par10s42-in-f14.1e100.net (216.58.214.174): icmp_seq=1 ttl=61 time=38.3 ms
^C64 bytes from 216.58.214.174: icmp_seq=2 ttl=61 time=43.0 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 38.276/40.625/42.975/2.349 ms
```

# III. Services réseau

## 1. DHCP


> Vous pouvez vous référer à [ce lien](https://www.server-world.info/en/note?os=Rocky_Linux_8&p=dhcp&f=1) ou n'importe quel autre truc sur internet (je sais c'est du Rocky 8, m'enfin, la conf de ce serveur DHCP ça bouge pas trop).

---

Pour ce qui est de la configuration du serveur DHCP, quelques précisions :

- vous ferez en sorte qu'il propose des adresses IPs entre `10.1.1.100` et `10.1.1.200`
- vous utiliserez aussi une option DHCP pour indiquer aux clients que la passerelle du réseau est `10.1.1.254` : le routeur
- vous utiliserez aussi une option DHCP pour indiquer aux clients qu'un serveur DNS joignable depuis le réseau c'est `1.1.1.1`

---

☀️ **Sur `dhcp.lan1.tp2`**

- n'oubliez pas de renommer la machine (`node2.lan1.tp2` devient `dhcp.lan1.tp2`)

```bash
[ahliko@dhcp ~]$ cat /etc/hostname 
dhcp.lan1.tp2
```

- changez son adresse IP en `10.1.1.253`

```bash
[ahliko@dhcp ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
NAME=enp0s8
DEVICE=enp0s8

BOOTPROTO=static
ONBOOT=yes

IPADDR=10.1.1.253
NETMASK=255.255.255.0

GATEWAY=10.1.1.254
DNS1=1.1.1.1
```

- setup du serveur DHCP
    - commande d'installation du paquet
    - fichier de conf
    - service actif

```bash
[ahliko@dhcp ~]$ dnf -y install dhcp-server
Error: This command has to be run with superuser privileges (under the root user on most systems).
[ahliko@dhcp ~]$ sudo !!
sudo dnf -y install dhcp-server
[sudo] password for ahliko: 
Rocky Linux 9 - BaseOS                                           7.8 kB/s | 4.1 kB     00:00    
Rocky Linux 9 - BaseOS                                           1.3 MB/s | 1.9 MB     00:01    
Rocky Linux 9 - AppStream                                        7.7 kB/s | 4.5 kB     00:00    
Rocky Linux 9 - AppStream                                        4.8 MB/s | 7.1 MB     00:01    
Rocky Linux 9 - Extras                                           5.8 kB/s | 2.9 kB     00:00    
Dependencies resolved.
=================================================================================================
 Package                Architecture      Version                        Repository         Size
=================================================================================================
Installing:
 dhcp-server            x86_64            12:4.4.2-18.b1.el9             baseos            1.2 M

Transaction Summary
=================================================================================================
Install  1 Package

Total download size: 1.2 M
Installed size: 3.9 M
Downloading Packages:
dhcp-server-4.4.2-18.b1.el9.x86_64.rpm                           2.0 MB/s | 1.2 MB     00:00    
-------------------------------------------------------------------------------------------------
Total                                                            1.2 MB/s | 1.2 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                         1/1 
  Running scriptlet: dhcp-server-12:4.4.2-18.b1.el9.x86_64                                   1/1 
  Installing       : dhcp-server-12:4.4.2-18.b1.el9.x86_64                                   1/1 
  Running scriptlet: dhcp-server-12:4.4.2-18.b1.el9.x86_64                                   1/1 
  Verifying        : dhcp-server-12:4.4.2-18.b1.el9.x86_64                                   1/1 

Installed:
  dhcp-server-12:4.4.2-18.b1.el9.x86_64                                                          

Complete!

[ahliko@dhcp ~]$ sudo cat /etc/dhcp/dhcpd.conf
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#

# create new
# specify domain name
option domain-name     "lan1.tp2";
# specify DNS server's hostname or IP address
option domain-name-servers     dhcp.lan1.tp2;
# default lease time
default-lease-time 600;
# max lease time
max-lease-time 7200;
# this DHCP server to be declared valid
authoritative;
# specify network address and subnetmask
subnet 10.1.1.0 netmask 255.255.255.0 {
    # specify the range of lease IP address
    range dynamic-bootp 10.1.1.100 10.1.1.200;
    # specify broadcast address
    option broadcast-address 10.1.1.255;
    # specify gateway
    option routers 10.1.1.254;
}

[ahliko@dhcp ~]$ systemctl status dhcpd
● dhcpd.service - DHCPv4 Server Daemon
     Loaded: loaded (/usr/lib/systemd/system/dhcpd.service; enabled; preset: disabled)
     Active: active (running) since Thu 2023-10-19 20:29:15 CEST; 3min 23s ago
       Docs: man:dhcpd(8)
             man:dhcpd.conf(5)
   Main PID: 804 (dhcpd)
     Status: "Dispatching packets..."
      Tasks: 1 (limit: 48872)
     Memory: 7.1M
        CPU: 7ms
     CGroup: /system.slice/dhcpd.service
             └─804 /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid

Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Config file: /etc/dhcp/dhcpd.conf
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Database file: /var/lib/dhcpd/dhcpd.leases
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: PID file: /var/run/dhcpd.pid
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Source compiled to use binary-leases
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Wrote 0 leases to leases file.
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Listening on LPF/enp0s8/08:00:27:39:b4:7e/10.1.1.0/24
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Sending on   LPF/enp0s8/08:00:27:39:b4:7e/10.1.1.0/24
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Sending on   Socket/fallback/fallback-net
Oct 19 20:29:15 dhcp.lan1.tp2 dhcpd[804]: Server starting service.
Oct 19 20:29:15 dhcp.lan1.tp2 systemd[1]: Started DHCPv4 Server Daemon.
```

☀️ **Sur `node1.lan1.tp2`**

- demandez une IP au serveur DHCP

```bash
[ahliko@node1 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
NAME=enp0s8
DEVICE=enp0s8

BOOTPROTO=dhcp
ONBOOT=yes
```

- prouvez que vous avez bien récupéré une IP *via* le DHCP

```bash
[ahliko@node1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:7b:9a:e1 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.100/24 brd 10.1.1.255 scope global dynamic noprefixroute enp0s8
       valid_lft 563sec preferred_lft 563sec
    inet6 fe80::a00:27ff:fe7b:9ae1/64 scope link 
       valid_lft forever preferred_lft forever
```

- prouvez que vous avez bien récupéré l'IP de la passerelle

```bash
[ahliko@node1 ~]$ ip r s
default via 10.1.1.254 dev enp0s8 proto dhcp src 10.1.1.100 metric 100 
10.1.1.0/24 dev enp0s8 proto kernel scope link src 10.1.1.100 metric 100
```

- prouvez que vous pouvez `ping node1.lan2.tp2`

```bash
[ahliko@node1 ~]$ ping node1.lan2.tp2
PING node1.lan2.tp2 (10.1.2.11) 56(84) bytes of data.
64 bytes from node1.lan2.tp2 (10.1.2.11): icmp_seq=1 ttl=63 time=0.444 ms
64 bytes from node1.lan2.tp2 (10.1.2.11): icmp_seq=2 ttl=63 time=0.449 ms
64 bytes from node1.lan2.tp2 (10.1.2.11): icmp_seq=3 ttl=63 time=0.462 ms
^C
--- node1.lan2.tp2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2085ms
rtt min/avg/max/mdev = 0.444/0.451/0.462/0.007 ms
```

## 2. Web web web

☀️ **Sur `web.lan2.tp2`**

- n'oubliez pas de renommer la machine (`node2.lan2.tp2` devient `web.lan2.tp2`)
- setup du service Web
    - installation de NGINX
    - gestion de la racine web `/var/www/site_nul/`
    - configuration NGINX
    - service actif
    - ouverture du port firewall
- prouvez qu'il y a un programme NGINX qui tourne derrière le port 80 de la machine (commande `ss`)
- prouvez que le firewall est bien configuré

```bash
[ahliko@web ~]$ cat /etc/hostname
web.lan2.tp1
[ahliko@web ~]$ sudo dnf install nginx
Rocky Linux 9 - BaseOS                                           7.8 kB/s | 4.1 kB     00:00    
Rocky Linux 9 - BaseOS                                           3.4 MB/s | 1.9 MB     00:00    
Rocky Linux 9 - AppStream                                         14 kB/s | 4.5 kB     00:00    
Rocky Linux 9 - AppStream                                        6.3 MB/s | 7.1 MB     00:01    
Rocky Linux 9 - Extras                                            11 kB/s | 2.9 kB     00:00    
Dependencies resolved.
=================================================================================================
 Package                   Architecture   Version                        Repository         Size
=================================================================================================
Installing:
 nginx                     x86_64         1:1.20.1-14.el9_2.1            appstream          36 k
Installing dependencies:
 nginx-core                x86_64         1:1.20.1-14.el9_2.1            appstream         565 k
 nginx-filesystem          noarch         1:1.20.1-14.el9_2.1            appstream         8.5 k
 rocky-logos-httpd         noarch         90.14-1.el9                    appstream          24 k

Transaction Summary
=================================================================================================
Install  4 Packages

Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-14.el9_2.1.noarch.rpm             116 kB/s | 8.5 kB     00:00    
(2/4): rocky-logos-httpd-90.14-1.el9.noarch.rpm                  265 kB/s |  24 kB     00:00    
(3/4): nginx-1.20.1-14.el9_2.1.x86_64.rpm                        352 kB/s |  36 kB     00:00    
(4/4): nginx-core-1.20.1-14.el9_2.1.x86_64.rpm                   3.7 MB/s | 565 kB     00:00    
-------------------------------------------------------------------------------------------------
Total                                                            1.2 MB/s | 634 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                         1/1 
  Running scriptlet: nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                             1/4 
  Installing       : nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                             1/4 
  Installing       : nginx-core-1:1.20.1-14.el9_2.1.x86_64                                   2/4 
  Installing       : rocky-logos-httpd-90.14-1.el9.noarch                                    3/4 
  Installing       : nginx-1:1.20.1-14.el9_2.1.x86_64                                        4/4 
  Running scriptlet: nginx-1:1.20.1-14.el9_2.1.x86_64                                        4/4 
  Verifying        : rocky-logos-httpd-90.14-1.el9.noarch                                    1/4 
  Verifying        : nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                             2/4 
  Verifying        : nginx-1:1.20.1-14.el9_2.1.x86_64                                        3/4 
  Verifying        : nginx-core-1:1.20.1-14.el9_2.1.x86_64                                   4/4 

Installed:
  nginx-1:1.20.1-14.el9_2.1.x86_64                   nginx-core-1:1.20.1-14.el9_2.1.x86_64       
  nginx-filesystem-1:1.20.1-14.el9_2.1.noarch        rocky-logos-httpd-90.14-1.el9.noarch        

Complete!

[ahliko@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[ahliko@web ~]$ sudo firewall-cmd --reload
success
[ahliko@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8
  sources: 
  services: cockpit dhcpv6-client http ssh
  ports: 80/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

[ahliko@web home]$ sudo systemctl start nginx

[ahliko@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Fri 2023-10-20 10:03:37 CEST; 1min 7s ago
    Process: 1386 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1387 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1388 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1389 (nginx)
      Tasks: 3 (limit: 48872)
     Memory: 4.2M
        CPU: 22ms
     CGroup: /system.slice/nginx.service
             ├─1389 "nginx: master process /usr/sbin/nginx"
             ├─1390 "nginx: worker process"
             └─1391 "nginx: worker process"

[ahliko@web home]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.

Oct 20 10:03:37 web.lan2.tp1 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Oct 20 10:03:37 web.lan2.tp1 nginx[1387]: nginx: the configuration file /etc/nginx/nginx.conf sy>
Oct 20 10:03:37 web.lan2.tp1 nginx[1387]: nginx: configuration file /etc/nginx/nginx.conf test i>
Oct 20 10:03:37 web.lan2.tp1 systemd[1]: Started The nginx HTTP and reverse proxy server.

[ahliko@web ~]$ sudo ss -alnpt | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1391,fd=6),("nginx",pid=1390,fd=6),("nginx",pid=1389,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1391,fd=7),("nginx",pid=1390,fd=7),("nginx",pid=1389,fd=7))


[ahliko@web ~]$ mkdir -p /var/www/site_nul
[ahliko@web ~]$ sudo chown -R $USER:$USER /var/www/site_nul

[ahliko@web ~]$ cat /var/www/site_nul/index.html
<html>
    <head>
        <title>Welcome to your_domain</title>
    </head>
    <body>
        <h1>Success! Your Nginx server is successfully configured for <em>your_domain</em>. </h1>
<p>This is a sample page.</p>
    </body>
</html>


```


☀️ **Sur `node1.lan1.tp2`**

- éditez le fichier `hosts` pour que `site_nul.tp2` pointe vers l'IP de `web.lan2.tp2`
- visitez le site nul avec une commande `curl` et en utilisant le nom `site_nul.tp2`

```bash
[ahliko@node1 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.1.1.100 node1.lan1.tp2
10.1.1.253 dhcp.lan1.tp2
10.1.2.11 node1.lan2.tp2
10.1.2.12 web.lan2.tp2 site_nul.tp2
10.1.2.254 router.tp2

[ahliko@node1 ~]$ curl site_nul.tp2
<html>
    <head>
        <title>Welcome to your_domain</title>
    </head>
    <body>
        <h1>Success! Your Nginx server is successfully configured for <em>your_domain</em>. </h1>
<p>This is a sample page.</p>
    </body>
</html>

```
