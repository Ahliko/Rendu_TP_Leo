# TP3 : On va router des trucs
## Sommaire

- [TP3 : On va router des trucs](#tp3--on-va-router-des-trucs)
  - [Sommaire](#sommaire)
  - [0. Prérequis](#0-prérequis)
  - [I. ARP](#i-arp)
    - [1. Echange ARP](#1-echange-arp)
    - [2. Analyse de trames](#2-analyse-de-trames)
  - [II. Routage](#ii-routage)
    - [1. Mise en place du routage](#1-mise-en-place-du-routage)
    - [2. Analyse de trames](#2-analyse-de-trames-1)
    - [3. Accès internet](#3-accès-internet)
  - [III. DHCP](#iii-dhcp)
    - [1. Mise en place du serveur DHCP](#1-mise-en-place-du-serveur-dhcp)
    - [2. Analyse de trames](#2-analyse-de-trames-2)

## I. ARP

### 1. Echange ARP

🌞**Générer des requêtes ARP**

### a.
```bash
$ ping 10.3.1.11
PING 10.3.1.11 (10.3.1.11) 56(84) bytes of data.
64 bytes from 10.3.1.11: icmp_seq=1 ttl=64 time=0.849 ms
64 bytes from 10.3.1.11: icmp_seq=2 ttl=64 time=1.06 ms
64 bytes from 10.3.1.11: icmp_seq=3 ttl=64 time=0.791 ms
^C
--- 10.3.1.11 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.791/0.899/1.059/0.115 ms
```
```bash
$ ping 10.3.1.12
PING 10.3.1.12 (10.3.1.12) 56(84) bytes of data.
64 bytes from 10.3.1.12: icmp_seq=1 ttl=64 time=1.74 ms
64 bytes from 10.3.1.12: icmp_seq=2 ttl=64 time=1.10 ms
^C
--- 10.3.1.12 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 1.098/1.417/1.736/0.319 ms
```
### b.
```bash
$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:01 DELAY
10.3.1.11 dev enp0s8 lladdr 08:00:27:37:a9:0a STALE
```
```bash
$ ip neigh show
10.3.1.12 dev enp0s8 lladdr 08:00:27:53:31:ba STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:01 REACHABLE
```
### c.

Marcel : 
```bash
$ ip neigh show 10.3.1.12
10.3.1.12 dev enp0s8 lladdr 08:00:27:53:31:ba STALE
```
John :
```bash
$ ip neigh show 10.3.1.11
10.3.1.11 dev enp0s8 lladdr 08:00:27:37:a9:0a STALE
```

### d.
```bash
$ ip neigh show 10.3.1.12
10.3.1.12 dev enp0s8 lladdr 08:00:27:53:31:ba STALE
```
```bash
$ ip a
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:53:31:ba brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.12/24 brd 10.3.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe53:31ba/64 scope link 
       valid_lft forever preferred_lft forever
```

### 2. Analyse de trames

🌞**Analyse de trames**

[Voir tp3_arp.pcapng](tp3_arp.pcapng)

## II. Routage

### 1. Mise en place du routage

🌞**Activer le routage sur le noeud `router`**

```bash
[ahliko@localhost ~]$ sudo firewall-cmd --list-all
[sudo] password for ahliko: 
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8 enp0s9
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
[ahliko@localhost ~]$ sudo firewall-cmd --get-active-zone
public
  interfaces: enp0s8 enp0s9
[ahliko@localhost ~]$ sudo firewall-cmd --add-masquerade --zone=public
success
[ahliko@localhost ~]$ sudo firewall-cmd --add-masquerade --zone=public --permanent
success
```

🌞**Ajouter les routes statiques nécessaires pour que `john` et `marcel` puissent se `ping`**

John :
```bash
[ahliko@localhost ~]$ cat /etc/sysconfig/network-scripts/route-enp0s8
10.3.2.0/24 via 10.3.1.254 dev enp0s8
```

Marcel :
```bash
[ahliko@localhost network-scripts]$ cat /etc/sysconfig/network-scripts/route-enp0s8
10.3.1.0/24 via 10.3.2.254 dev enp0s8
```

### 2. Analyse de trames

🌞**Analyse des échanges ARP**

```bash
sudo ip neigh flush all
```

John :
```bash
[ahliko@localhost ~]$ ping 10.3.2.12
PING 10.3.2.12 (10.3.2.12) 56(84) bytes of data.
64 bytes from 10.3.2.12: icmp_seq=1 ttl=63 time=3.06 ms
64 bytes from 10.3.2.12: icmp_seq=2 ttl=63 time=0.916 ms
64 bytes from 10.3.2.12: icmp_seq=3 ttl=63 time=0.759 ms
^C
--- 10.3.2.12 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.759/1.577/3.058/1.048 ms
```
John :
```bash
[ahliko@localhost ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:01 DELAY
10.3.1.254 dev enp0s8 lladdr 08:00:27:5a:b5:af STALE
```
Marcel :
```bash
[ahliko@localhost network-scripts]$ ip neigh show
10.3.2.254 dev enp0s8 lladdr 08:00:27:9f:df:9e STALE
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:02 DELAY
```

Routeur :
```bash
[ahliko@localhost ~]$ ip neigh show
10.3.1.11 dev enp0s8 lladdr 08:00:27:55:21:0c STALE
10.3.2.12 dev enp0s9 lladdr 08:00:27:09:d4:8d STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:01 DELAY
```
Pour John :
10.3.1.1 = 0a:00:27:00:00:01, c'est l'adresse MAC de la carte réseau<br/>
10.3.1.254 = 08:00:27:5a:b5:af, c'est l'adresse MAC de la passerelle.

Pour Marcel :
10.3.2.1 = 0a:00:27:00:00:02, c'est l'adresse MAC de la carte réseau de Marcel<br/>
10.3.2.254 = 08:00:27:9f:df:9e, c'est l'adresse MAC de la passerelle.

Pour le routeur :
10.3.1.1 = 0a:00:27:00:00:01, c'est l'adresse MAC de la carte réseau <br/>
10.3.1.11 = 08:00:27:55:21:0c, c'est l'adresse MAC de John <br/>
10.3.2.12 = 08:00:27:09:d4:8d, c'est l'adresse MAC de Marcel.

| ordre | type trame  | IP source  | MAC source            | IP destination | MAC destination           |
|-------|-------------|------------|-----------------------|----------------|---------------------------|
| 1     | Requête ARP | 10.3.2.12  | Marcel<br/>`AA:BB:CC:DD:EE` | 10.3.2.254     | Broadcast `FF:FF:FF:FF:FF` |
| 2     | Réponse ARP | 10.3.2.254 | Broadcast `FF:FF:FF:FF:FF`| 10.3.2.12      | `marcel` `AA:BB:CC:DD:EE`   |
| 3     | Ping        | 10.3.2.254 | Broadcast `FF:FF:FF:FF:FF`| 10.3.2.12      | `marcel` `AA:BB:CC:DD:EE`|
| 4     | Pong        | 10.3.2.12      | `marcel` `AA:BB:CC:DD:EE`| 10.3.2.254 | Broadcast `FF:FF:FF:FF:FF`|



### 3. Accès internet

🌞**Donnez un accès internet à vos machines**
John :
```bash
[ahliko@localhost ~]$ cat /etc/sysconfig/network
# Created by anaconda
GATEWAY=10.3.1.254
```
```bash
[ahliko@localhost ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=23.4 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=61 time=22.0 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 21.953/22.678/23.404/0.725 ms
```

Marcel :
```bash
[ahliko@localhost ~]$ cat /etc/sysconfig/network
# Created by anaconda
GATEWAY=10.3.2.254
```

```bash
[ahliko@localhost ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=22.7 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=61 time=58.3 ms
^C
--- 1.1.1.1 ping statistics ---
3 packets transmitted, 2 received, 33.3333% packet loss, time 2003ms
rtt min/avg/max/mdev = 22.732/40.494/58.256/17.762 ms
```

John :
```bash
[ahliko@localhost ~]$ ping google.com
PING google.com (216.58.201.238) 56(84) bytes of data.
64 bytes from fra02s18-in-f14.1e100.net (216.58.201.238): icmp_seq=1 ttl=61 time=22.0 ms
64 bytes from fra02s18-in-f14.1e100.net (216.58.201.238): icmp_seq=2 ttl=61 time=24.8 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 22.048/23.435/24.823/1.387 ms
```

Marcel :
```bash
[ahliko@localhost ~]$ ping google.com
PING google.com (216.58.198.206) 56(84) bytes of data.
64 bytes from par10s27-in-f206.1e100.net (216.58.198.206): icmp_seq=1 ttl=61 time=22.9 ms
64 bytes from par10s27-in-f14.1e100.net (216.58.198.206): icmp_seq=2 ttl=61 time=23.8 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 22.891/23.334/23.778/0.443 ms
```

🌞**Analyse de trames**

| ordre | type trame | IP source            | MAC source                 | IP destination | MAC destination |     |
|-------|------------|----------------------|----------------------------|----------------|--------------|-----|
| 1     | ping       | `marcel` `10.3.1.12` | `john` `08:00:27:55:21:0c` | `8.8.8.8`      | `08:00:27:5a:b5:af`|     |
| 2     | pong       | 8.8.8.8              | `08:00:27:5a:b5:af`| 10.3.1.11      | `john` `08:00:27:55:21:0c`| ... |

## III. DHCP

### 1. Mise en place du serveur DHCP

🌞**Sur la machine `john`, vous installerez et configurerez un serveur DHCP** (go Google "rocky linux dhcp server").

Server :
```bash
[ahliko@localhost ~]$ sudo cat /etc/dhcp/dhcpd.conf
[sudo] password for ahliko: 
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
default-lease-time 900;
max-lease-time 10800;

authoritative;

subnet 10.3.1.0 netmask 255.255.255.0 {
range 10.3.1.1 10.3.1.254;
option routers 10.3.1.254;
option subnet-mask 255.255.255.0;
option domain-name-servers 1.1.1.1;
}
```

```bash
[ahliko@localhost ~]$ sudo systemctl status dhcpd
● dhcpd.service - DHCPv4 Server Daemon
     Loaded: loaded (/usr/lib/systemd/system/dhcpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-10-24 11:22:24 CEST; 15min ago
       Docs: man:dhcpd(8)
             man:dhcpd.conf(5)
   Main PID: 1289 (dhcpd)
     Status: "Dispatching packets..."
      Tasks: 1 (limit: 5906)
     Memory: 4.7M
        CPU: 9ms
     CGroup: /system.slice/dhcpd.service
             └─1289 /usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid

Oct 24 11:22:24 localhost.localdomain systemd[1]: Started DHCPv4 Server Daemon.
Oct 24 11:26:09 localhost.localdomain dhcpd[1289]: DHCPDISCOVER from 08:00:27:d9:79:3d via enp0s8
Oct 24 11:26:09 localhost.localdomain dhcpd[1289]: ICMP Echo reply while lease 10.3.1.1 valid.
Oct 24 11:26:09 localhost.localdomain dhcpd[1289]: Abandoning IP address 10.3.1.1: pinged before offer
Oct 24 11:26:11 localhost.localdomain dhcpd[1289]: DHCPDISCOVER from 08:00:27:d9:79:3d via enp0s8
Oct 24 11:26:12 localhost.localdomain dhcpd[1289]: DHCPOFFER on 10.3.1.2 to 08:00:27:d9:79:3d via enp0s8
Oct 24 11:26:12 localhost.localdomain dhcpd[1289]: DHCPREQUEST for 10.3.1.2 (10.3.1.11) from 08:00:27:d9:79:3d via enp0s8
Oct 24 11:26:12 localhost.localdomain dhcpd[1289]: DHCPACK on 10.3.1.2 to 08:00:27:d9:79:3d via enp0s8
Oct 24 11:33:43 localhost.localdomain dhcpd[1289]: DHCPREQUEST for 10.3.1.2 from 08:00:27:d9:79:3d via enp0s8
Oct 24 11:33:43 localhost.localdomain dhcpd[1289]: DHCPACK on 10.3.1.2 to 08:00:27:d9:79:3d via enp0s8
```

Client :
```bash
[ahliko@localhost ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8 
DEVICE=enp0s8

BOOTPROTO=dhcp
ONBOOT=yes
```

```bash
[ahliko@localhost ~]$ sudo nmcli con up "System enp0s8"
[sudo] password for ahliko: 
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
```
Preuve de fonctionnement :

```bash
[ahliko@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:d9:79:3d brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.2/24 brd 10.3.1.255 scope global dynamic noprefixroute enp0s8
       valid_lft 863sec preferred_lft 863sec
    inet6 fe80::a00:27ff:fed9:793d/64 scope link 
       valid_lft forever preferred_lft forever
```
🌞**Améliorer la configuration du DHCP**

```bash
option routers 10.3.1.254;
option subnet-mask 255.255.255.0;
option domain-name-servers 1.1.1.1;
```


```bash
[ahliko@localhost ~]$ sudo nmcli con down "System enp0s8"
```

```bash
[ahliko@localhost ~]$ sudo nmcli con up "System enp0s8"
```

```bash
[ahliko@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:d9:79:3d brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.2/24 brd 10.3.1.255 scope global dynamic noprefixroute enp0s8
       valid_lft 882sec preferred_lft 882sec
    inet6 fe80::a00:27ff:fed9:793d/64 scope link 
       valid_lft forever preferred_lft forever
```

```bash
[ahliko@localhost ~]$ ping 10.3.1.254
PING 10.3.1.254 (10.3.1.254) 56(84) bytes of data.
64 bytes from 10.3.1.254: icmp_seq=1 ttl=64 time=0.521 ms
64 bytes from 10.3.1.254: icmp_seq=2 ttl=64 time=0.744 ms
^C
--- 10.3.1.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.521/0.632/0.744/0.111 ms
```
```bash
[ahliko@localhost ~]$ ip r s
default via 10.3.1.254 dev enp0s8 proto dhcp src 10.3.1.2 metric 100 
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.2 metric 100 
```
```bash
[ahliko@localhost ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=21.5 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=61 time=22.9 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 21.475/22.164/22.854/0.689 ms
```

```bash
[ahliko@localhost ~]$ dig google.com

; <<>> DiG 9.16.23-RH <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 4468
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             36      IN      A       142.250.179.110

;; Query time: 24 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Mon Oct 24 12:37:33 CEST 2022
;; MSG SIZE  rcvd: 55

```

```bash
[ahliko@localhost ~]$ ping google.com
PING google.com (216.58.198.206) 56(84) bytes of data.
64 bytes from par10s27-in-f206.1e100.net (216.58.198.206): icmp_seq=1 ttl=61 time=29.9 ms
64 bytes from par10s27-in-f206.1e100.net (216.58.198.206): icmp_seq=2 ttl=61 time=22.4 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 22.392/26.127/29.863/3.735 ms
```

### 2. Analyse de trames

🌞**Analyse de trames**

[pcapng](tp3_dhcp.pcapng)