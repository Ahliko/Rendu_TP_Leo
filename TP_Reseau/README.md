# TP1 - Premier pas réseau

# Sommaire
- [TP1 - Premier pas réseau](#tp1---premier-pas-réseau)
- [Sommaire](#sommaire)
- [I. Exploration locale en solo](#i-exploration-locale-en-solo)
  - [1. Affichage d'informations sur la pile TCP/IP locale](#1-affichage-dinformations-sur-la-pile-tcpip-locale)
    - [En ligne de commande](#en-ligne-de-commande)
    - [En graphique (GUI : Graphical User Interface)](#en-graphique-gui--graphical-user-interface)
  - [2. Modifications des informations](#2-modifications-des-informations)
    - [A. Modification d'adresse IP (part 1)](#a-modification-dadresse-ip-part-1)
- [II. Exploration locale en duo](#ii-exploration-locale-en-duo)
  - [1. Prérequis](#1-prérequis)
  - [2. Câblage](#2-câblage)
  - [Création du réseau (oupa)](#création-du-réseau-oupa)
  - [3. Modification d'adresse IP](#3-modification-dadresse-ip)
  - [4. Utilisation d'un des deux comme gateway](#4-utilisation-dun-des-deux-comme-gateway)
  - [5. Petit chat privé](#5-petit-chat-privé)
  - [6. Firewall](#6-firewall)
- [III. Manipulations d'autres outils/protocoles côté client](#iii-manipulations-dautres-outilsprotocoles-côté-client)
  - [1. DHCP](#1-dhcp)
  - [2. DNS](#2-dns)
- [IV. Wireshark](#iv-wireshark)
- [Bilan](#bilan)

# I. Exploration locale en solo

## 1. Affichage d'informations sur la pile TCP/IP locale

### En ligne de commande

En utilisant la ligne de commande (CLI) de votre OS : 

(Manjaro KDE Plasma)

**🌞 Affichez les infos des cartes réseau de votre PC**

```bash
$ ip a
eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 88:a4:c2:ac:a8:2b brd ff:ff:ff:ff:ff:ff
    altname enp3s0
wlp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether e0:0a:f6:6d:2d:fd brd ff:ff:ff:ff:ff:ff
    inet 10.33.16.144/22 brd 10.33.19.255 scope global dynamic noprefixroute wlp4s0
       valid_lft 84765sec preferred_lft 84765sec
    inet6 fe80::6c4d:5cf4:2615:c6be/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

**🌞 Affichez votre gateway**

```bash
$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.33.19.254    0.0.0.0         UG    600    0        0 wlp4s0
10.33.16.0      0.0.0.0         255.255.252.0   U     600    0        0 wlp4s0
```

**🌞 Déterminer la MAC de la passerelle**

```bash
$ arp
Address                  HWtype  HWaddress           Flags Mask            Iface
_gateway                 ether   00:c0:e7:e0:04:4e   C                     wlp4s0
10.33.18.221             ether   78:4f:43:87:f5:11   C                     wlp4s0
```

### En graphique (GUI : Graphical User Interface)

En utilisant l'interface graphique de votre OS :  

**🌞 Trouvez comment afficher les informations sur une carte IP (change selon l'OS)**

Sous KDE Plasma donc impossible :+1: 

## 2. Modifications des informations

### A. Modification d'adresse IP (part 1)  

🌞 Utilisez l'interface graphique de votre OS pour **changer d'adresse IP** :

![](https://i.imgur.com/XYJBND8.png)


🌞 **Il est possible que vous perdiez l'accès internet.** 

L'adresse IP que j'ai saisie doit être déjà utilisée.

# II. Exploration locale en duo

## 3. Modification d'adresse IP

🌞 **Modifiez l'IP des deux machines pour qu'elles soient dans le même réseau**
![](https://i.imgur.com/SsbjldM.png)


🌞 **Vérifier à l'aide d'une commande que votre IP a bien été changée**
```bash
$ ip a
eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 88:a4:c2:ac:a8:2b brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 10.10.10.2/24 brd 10.10.10.255 scope global noprefixroute eno1
       valid_lft forever preferred_lft forever
    inet6 fe80::57e1:bce0:e957:3dce/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
🌞 **Vérifier que les deux machines se joignent**

```bash
$ ping 10.10.10.1                                                1 ✘  12s  
PING 10.10.10.1 (10.10.10.1) 56(84) octets de données.
64 octets de 10.10.10.1 : icmp_seq=1 ttl=128 temps=1.86 ms
64 octets de 10.10.10.1 : icmp_seq=2 ttl=128 temps=2.73 ms
64 octets de 10.10.10.1 : icmp_seq=3 ttl=128 temps=1.71 ms
64 octets de 10.10.10.1 : icmp_seq=4 ttl=128 temps=1.85 ms
64 octets de 10.10.10.1 : icmp_seq=5 ttl=128 temps=2.06 ms
64 octets de 10.10.10.1 : icmp_seq=6 ttl=128 temps=1.70 ms
64 octets de 10.10.10.1 : icmp_seq=7 ttl=128 temps=1.89 ms
^C
--- statistiques ping 10.10.10.1 ---
7 paquets transmis, 7 reçus, 0% packet loss, time 6009ms
rtt min/avg/max/mdev = 1.700/1.970/2.734/0.331 ms
```

🌞 **Déterminer l'adresse MAC de votre correspondant**

```bash
$ arp
Address                  HWtype  HWaddress           Flags Mask            Iface
_gateway                 ether   00:c0:e7:e0:04:4e   C                     wlp4s0
10.10.10.1               ether   88:a4:c2:9c:99:84   C                     eno1
10.33.16.21              ether   7e:17:d1:8a:53:e6   C                     wlp4s0
_gateway                         (incomplete)                              eno1
```

## 4. Utilisation d'un des deux comme gateway


🌞**Tester l'accès internet**
```bash
$ ping 1.1.1                                                     ✔  3m 8s  
PING 1.1.1.1 (1.1.1.1) 56(84) octets de données.
64 octets de 1.1.1.1 : icmp_seq=1 ttl=55 temps=28.2 ms
64 octets de 1.1.1.1 : icmp_seq=2 ttl=55 temps=50.6 ms
^C
--- statistiques ping 1.1.1.1 ---
2 paquets transmis, 2 reçus, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 28.174/39.398/50.623/11.224 ms
```

🌞 **Prouver que la connexion Internet passe bien par l'autre PC**

Voir TP de Mathieu.Bo

## 5. Petit chat privé

🌞 **sur le PC *serveur*** avec par exemple l'IP 192.168.1.1
``` bash
$ netcat                                                                                                                                                       127 ✘  47s  
Cmd line: -l -p 8888
g
coucou
Bonsoir !
Miaou
```

🌞 **sur le PC *client*** avec par exemple l'IP 192.168.1.2

Voir Mathieu 

🌞 **Visualiser la connexion en cours**

```bash 
$ ss -atnp                                                                                                                                                                 ✔ 
State                Recv-Q           Send-Q                     Local Address:Port                         Peer Address:Port            Process                                               
LISTEN               0                511                            127.0.0.1:6463                              0.0.0.0:*                users:(("Discord",pid=2021,fd=60))                   
LISTEN               0                511                            127.0.0.1:35367                             0.0.0.0:*                users:(("github-desktop",pid=13371,fd=81))           
LISTEN               0                32                            10.10.10.2:53                                0.0.0.0:*                                                                     
LISTEN               0                128                            127.0.0.1:631                               0.0.0.0:*                                                                     
ESTAB                0                0                           10.33.16.144:40434                        104.18.8.221:443              users:(("opera",pid=1983,fd=31))                     
ESTAB                0                0                           10.33.16.144:55686                        104.18.8.221:443              users:(("opera",pid=1983,fd=26))                     
ESTAB                0                0                           10.33.16.144:42404                     142.250.178.138:443              users:(("insync",pid=1426,fd=84))                    
ESTAB                0                0                           10.33.16.144:43254                     192.241.190.146:443              users:(("opera",pid=1983,fd=67))                     
ESTAB                0                0                           10.33.16.144:52760                     151.101.194.217:443              users:(("opera",pid=1983,fd=40))                     
ESTAB                0                0                           10.33.16.144:59550                     185.199.111.133:443              users:(("opera",pid=1983,fd=30))                     
ESTAB                0                0                           10.33.16.144:59172                        104.18.8.221:443              users:(("opera",pid=1983,fd=41))                     
ESTAB                0                0                           10.33.16.144:59930                       140.82.114.26:443              users:(("opera",pid=1983,fd=25))                     
ESTAB                0                0                           10.33.16.144:40686                     142.250.179.109:443              users:(("insync",pid=1426,fd=86))                    
ESTAB                0                0                             10.10.10.2:8888                           10.10.10.1:63681            users:(("netcat",pid=31416,fd=4))                    
CLOSE-WAIT           1                0                           10.33.16.144:55738                      52.219.197.106:443              users:(("opera",pid=1983,fd=44))                     
FIN-WAIT-1           0                518                         10.33.16.144:57338                       162.125.67.18:443                                                                   
CLOSE-WAIT           32               0                           10.33.16.144:55742                      52.219.197.106:443              users:(("opera",pid=1983,fd=47))                     
ESTAB                0                0                           10.33.16.144:60646                        104.18.9.221:443              users:(("opera",pid=1983,fd=49))                     
ESTAB                0                0                           10.33.16.144:40822                     162.159.133.234:443              users:(("Discord",pid=1874,fd=25))                   
CLOSE-WAIT           0                0                           10.33.16.144:44360                        140.82.121.6:443              users:(("github-desktop",pid=13363,fd=24))           
ESTAB                0                0                           10.33.16.144:51922                       140.82.113.25:443              users:(("github-desktop",pid=13363,fd=23))           
ESTAB                0                0                           10.33.16.144:50104                         13.225.34.3:443              users:(("opera",pid=1983,fd=35))                     
ESTAB                0                0                           10.33.16.144:50316                     162.159.133.232:443              users:(("Discord",pid=1874,fd=28))                   
ESTAB                0                0                           10.33.16.144:54200                         75.2.77.152:443              users:(("opera",pid=1983,fd=48))                     
TIME-WAIT            0                0                           10.33.16.144:52896                       35.186.224.47:443                                                                   
ESTAB                0                0                           10.33.16.144:43862                     162.159.137.234:443              users:(("Discord",pid=1874,fd=34))                   
ESTAB                0                0                           10.33.16.144:54066                       35.186.224.25:443              users:(("Discord",pid=1874,fd=32))                   
LISTEN               0                50                                     *:1716                                    *:*                users:(("kdeconnectd",pid=1034,fd=12))               
LISTEN               0                128                                [::1]:631                                  [::]:*
```

🌞 **Pour aller un peu plus loin**

```bash 
sudo ss -atpnl                                                                                                                                                       INT ✘ 
State             Recv-Q            Send-Q                       Local Address:Port                        Peer Address:Port            Process                                                
LISTEN            0                 511                              127.0.0.1:6463                             0.0.0.0:*                users:(("Discord",pid=2021,fd=60))                    
LISTEN            0                 511                              127.0.0.1:35367                            0.0.0.0:*                users:(("github-desktop",pid=13371,fd=81))            
LISTEN            0                 32                              10.10.10.2:53                               0.0.0.0:*                users:(("dnsmasq",pid=26273,fd=7))                    
LISTEN            0                 128                              127.0.0.1:631                              0.0.0.0:*                users:(("cupsd",pid=572,fd=8))                        
LISTEN            0                 4                               10.10.10.2:8888                             0.0.0.0:*                users:(("nc",pid=32060,fd=3))                         
LISTEN            0                 50                                       *:1716                                   *:*                users:(("kdeconnectd",pid=1034,fd=12))                
LISTEN            0                 128                                  [::1]:631                                 [::]:*                users:(("cupsd",pid=572,fd=7))
```

## 6. Firewall

🌞 **Activez et configurez votre firewall**

- autoriser les `ping`
```bash 
  sudo iptables -vnL | grep -i icmp                                                                                                                                        ✔ 
    0     0 REJECT     all  --  *      eno1    0.0.0.0/0            0.0.0.0/0            reject-with icmp-port-unreachable
    0     0 REJECT     all  --  eno1   *       0.0.0.0/0            0.0.0.0/0            reject-with icmp-port-unreachable
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 3
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 11
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 12
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 3
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 11
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 12
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8
    0     0 REJECT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            reject-with icmp-port-unreachable
```
- autoriser le traffic sur le port qu'utilise `nc`
```bash 
  sudo iptables -vnL | grep -i 8888                                                                                                                                        ✔ 
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:8888
```
  
# III. Manipulations d'autres outils/protocoles côté client

## 1. DHCP

Bon ok vous savez définir des IPs à la main. Mais pour être dans le réseau YNOV, vous l'avez jamais fait.  

C'est le **serveur DHCP** d'YNOV qui vous a donné une IP.

Une fois que le serveur DHCP vous a donné une IP, vous enregistrer un fichier appelé *bail DHCP* qui contient, entre autres :

- l'IP qu'on vous a donné
- le réseau dans lequel cette IP est valable

🌞**Exploration du DHCP, depuis votre PC**

```bash 
sudo nmcli con show "WiFi@YNOV" | grep -i dhcp                                                                                                                           ✔ 
ipv4.dhcp-client-id:                    --
ipv4.dhcp-iaid:                         --
ipv4.dhcp-timeout:                      0 (default)
ipv4.dhcp-send-hostname:                oui
ipv4.dhcp-hostname:                     --
ipv4.dhcp-fqdn:                         --
ipv4.dhcp-hostname-flags:               0x0 (none)
ipv4.dhcp-vendor-class-identifier:      --
ipv4.dhcp-reject-servers:               --
ipv6.dhcp-duid:                         --
ipv6.dhcp-iaid:                         --
ipv6.dhcp-timeout:                      0 (default)
ipv6.dhcp-send-hostname:                oui
ipv6.dhcp-hostname:                     --
ipv6.dhcp-hostname-flags:               0x0 (none)
DHCP4.OPTION[1]:                        dhcp_lease_time = 74727
DHCP4.OPTION[2]:                        dhcp_server_identifier = 10.33.19.254
```

## 2. DNS

Le protocole DNS permet la résolution de noms de domaine vers des adresses IP. Ce protocole permet d'aller sur `google.com` plutôt que de devoir connaître et utiliser l'adresse IP du serveur de Google.  

Un **serveur DNS** est un serveur à qui l'on peut poser des questions (= effectuer des requêtes) sur un nom de domaine comme `google.com`, afin d'obtenir les adresses IP liées au nom de domaine.  

Si votre navigateur fonctionne "normalement" (il vous permet d'aller sur `google.com` par exemple) alors votre ordinateur connaît forcément l'adresse d'un serveur DNS. Et quand vous naviguez sur internet, il effectue toutes les requêtes DNS à votre place, de façon automatique.

🌞** Trouver l'adresse IP du serveur DNS que connaît votre ordinateur**

🌞 Utiliser, en ligne de commande l'outil `nslookup` (Windows, MacOS) ou `dig` (GNU/Linux, MacOS) pour faire des requêtes DNS à la main

- faites un *lookup* (*lookup* = "dis moi à quelle IP se trouve tel nom de domaine")
  - pour `google.com`
  - pour `ynov.com`
  - interpréter les résultats de ces commandes
- déterminer l'adresse IP du serveur à qui vous venez d'effectuer ces requêtes
- faites un *reverse lookup* (= "dis moi si tu connais un nom de domaine pour telle IP")
  - pour l'adresse `78.73.21.21`
  - pour l'adresse `22.146.54.58`
  - interpréter les résultats
  - *si vous vous demandez, j'ai pris des adresses random :)*

# IV. Wireshark

**Wireshark est un outil qui permet de visualiser toutes les trames qui sortent et entrent d'une carte réseau.**

On appelle ça un **sniffer**, ou **analyseur de trames.**

![Wireshark](./pics/wireshark.jpg)

Il peut :

- enregistrer le trafic réseau, pour l'analyser plus tard
- afficher le trafic réseau en temps réel

**On peut TOUT voir.**

Un peu austère aux premiers abords, une manipulation très basique permet d'avoir une très bonne compréhension de ce qu'il se passe réellement.

➜ **[Téléchargez l'outil Wireshark](https://www.wireshark.org/).**

🌞 Utilisez le pour observer les trames qui circulent entre vos deux carte Ethernet. Mettez en évidence :

- un `ping` entre vous et votre passerelle
- un `netcat` entre vous et votre mate, branché en RJ45
- une requête DNS. Identifiez dans la capture le serveur DNS à qui vous posez la question.
- prenez moi des screens des trames en question
- on va prendre l'habitude d'utiliser Wireshark souvent dans les cours, pour visualiser ce qu'il se passe

# Bilan

**Vu pendant le TP :**

- visualisation de vos interfaces réseau (en GUI et en CLI)
- extraction des informations IP
  - adresse IP et masque
  - calcul autour de IP : adresse de réseau, etc.
- connaissances autour de/aperçu de :
  - un outil de diagnostic simple : `ping`
  - un outil de scan réseau : `nmap`
  - un outil qui permet d'établir des connexions "simples" (on y reviendra) : `netcat`
  - un outil pour faire des requêtes DNS : `nslookup` ou `dig`
  - un outil d'analyse de trafic : `wireshark`
- manipulation simple de vos firewalls

**Conclusion :**

- Pour permettre à un ordinateur d'être connecté en réseau, il lui faut **une liaison physique** (par câble ou par *WiFi*).  
- Pour réceptionner ce lien physique, l'ordinateur a besoin d'**une carte réseau**. La carte réseau porte une adresse MAC  
- **Pour être membre d'un réseau particulier, une carte réseau peut porter une adresse IP.**
Si deux ordinateurs reliés physiquement possèdent une adresse IP dans le même réseau, alors ils peuvent communiquer.  
- **Un ordintateur qui possède plusieurs cartes réseau** peut réceptionner du trafic sur l'une d'entre elles, et le balancer sur l'autre, servant ainsi de "pivot". Cet ordinateur **est appelé routeur**.
- Il existe dans la plupart des réseaux, certains équipements ayant un rôle particulier :
  - un équipement appelé *passerelle*. C'est un routeur, et il nous permet de sortir du réseau actuel, pour en joindre un autre, comme Internet par exemple
  - un équipement qui agit comme **serveur DNS** : il nous permet de connaître les IP derrière des noms de domaine
  - un équipement qui agit comme **serveur DHCP** : il donne automatiquement des IP aux clients qui rejoigne le réseau
  - **chez vous, c'est votre Box qui fait les trois :)**