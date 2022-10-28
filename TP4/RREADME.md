# TP4 : TCP, UDP et services réseau

# Sommaire

- [TP4 : TCP, UDP et services réseau](#tp4--tcp-udp-et-services-réseau)
- [Sommaire](#sommaire)
- [0. Prérequis](#0-prérequis)
- [I. First steps](#i-first-steps)
- [II. Mise en place](#ii-mise-en-place)
    - [1. SSH](#1-ssh)
    - [2. Routage](#2-routage)
- [III. DNS](#iii-dns)
    - [1. Présentation](#1-présentation)
    - [2. Setup](#2-setup)
    - [3. Test](#3-test)

# I. First steps

🌞 **Déterminez, pour ces 5 applications, si c'est du TCP ou de l'UDP**

- `Spotify`
  - Local : `41234`
  - Distant : `35.186.224.47:443`
- `Opera`
    - Local : `49054`
    - Distant : `35.186.224.47:443`
- `Discord`
  - Local : `37364`
  - Distant : `162.159.128.233:443`
- `Epic Games Launcher`
  - Local : `37524`
  - Distant : `23.23.106.155:443`
- `VSCode`
  - Local : `37348`
  - Distant : `51.144.164.215:443`

<br>
🌞 **Demandez l'avis à votre OS**

```bash
[ahliko@ahliko-pc TP4]$ sudo ss -ptun
Netid            State                 Recv-Q            Send-Q                             Local Address:Port                               Peer Address:Port             Process                                                 
udp              ESTAB                 0                 0                                   10.33.16.229:46366                             35.186.224.25:443               users:(("Discord",pid=26377,fd=27))                    
udp              ESTAB                 0                 0                                   10.33.16.229:49054                           162.159.128.233:443               users:(("Discord",pid=26377,fd=25))                    
udp              ESTAB                 0                 0                            10.33.16.229%wlp4s0:68                                 10.33.19.254:67                users:(("NetworkManager",pid=1298,fd=26))              
tcp              ESTAB                 0                 0                                   10.33.16.229:40528                              66.102.1.188:5228              users:(("opera",pid=22164,fd=75))                      
tcp              ESTAB                 0                 0                                   10.33.16.229:52748                           162.159.133.234:443               users:(("Discord",pid=26377,fd=145))                   
tcp              ESTAB                 0                 0                                      127.0.0.1:54112                                 127.0.0.1:63342             users:(("jcef_helper",pid=24394,fd=26))                
tcp              ESTAB                 0                 0                                   10.33.16.229:52498                              51.195.5.156:443               users:(("anydesk",pid=1526,fd=45))                     
tcp              ESTAB                 0                 0                                   10.33.16.229:42698                            185.26.182.111:443               users:(("opera",pid=22164,fd=25))                      
tcp              ESTAB                 0                 0                                   10.33.16.229:45692                             35.186.224.25:443               users:(("Discord",pid=26377,fd=28))                    
tcp              ESTAB                 0                 0                                   10.33.16.229:58388                             20.250.85.194:443               users:(("copilot-agent-l",pid=24357,fd=20))            
tcp              CLOSE-WAIT            25                0                                   10.33.16.229:43750                             82.145.216.16:443               users:(("opera",pid=22164,fd=32))                      
tcp              ESTAB                 0                 0                                   10.33.16.229:53736                           192.241.190.146:443               users:(("opera",pid=22164,fd=69))                      
tcp              ESTAB                 0                 0                                   10.33.16.229:33522                             140.82.112.26:443               users:(("opera",pid=22164,fd=53))                      
tcp              ESTAB                 0                 585                                 10.33.16.229:33544                              3.213.18.157:443               users:(("opera",pid=22164,fd=29))                      
tcp              ESTAB                 0                 0                             [::ffff:127.0.0.1]:63342                        [::ffff:127.0.0.1]:54112             users:(("java",pid=24205,fd=35))  
```
# II. Mise en place

## 1. SSH

🌞 **Examinez le trafic dans Wireshark**

[Voir fichier Capture_SSH](Capture_SSH.pcapng)

🌞 **Demandez aux OS**

- repérez, avec une commande adaptée (`netstat` ou `ss`), la connexion SSH depuis votre machine
- ET repérez la connexion SSH depuis votre VM

🦈 **Je veux une capture clean avec le 3-way handshake, un peu de trafic au milieu et une fin de connexion**

## 2. Routage

Ouais, un peu de répétition, ça fait jamais de mal. On va créer une machine qui sera notre routeur, et **permettra à toutes les autres machines du réseau d'avoir Internet.**

🖥️ **Machine `router.tp4.b1`**

- n'oubliez pas de dérouler la checklist (voir [les prérequis du TP](#0-prérequis))
- donnez lui l'adresse IP `10.4.1.254/24` sur sa carte host-only
- ajoutez-lui une carte NAT, qui permettra de donner Internet aux autres machines du réseau
- référez-vous au TP précédent

> Rien à remettre dans le compte-rendu pour cette partie.

# III. DNS

## 1. Présentation

Un serveur DNS est un serveur qui est capable de répondre à des requêtes DNS.

Une requête DNS est la requête effectuée par une machine lorsqu'elle souhaite connaître l'adresse IP d'une machine, lorsqu'elle connaît son nom.

Par exemple, si vous ouvrez un navigateur web et saisissez `https://www.google.com` alors une requête DNS est automatiquement effectuée par votre PC pour déterminez à quelle adresse IP correspond le nom `www.google.com`.

> La partie `https://` ne fait pas partie du nom de domaine, ça indique simplement au navigateur la méthode de connexion. Ici, c'est HTTPS.

Dans cette partie, on va monter une VM qui porte un serveur DNS. Ce dernier répondra aux autres VMs du LAN quand elles auront besoin de connaître des noms. Ainsi, ce serveur pourra :

- résoudre des noms locaux
    - vous pourrez `ping node1.tp4.b1` et ça fonctionnera
    - mais aussi `ping www.google.com` et votre serveur DNS sera capable de le résoudre aussi

*Dans la vraie vie, il n'est pas rare qu'une entreprise gère elle-même ses noms de domaine, voire gère elle-même son serveur DNS. C'est donc du savoir ré-utilisable pour tous qu'on voit ici.*

> En réalité, ce n'est pas votre serveur DNS qui pourra résoudre `www.google.com`, mais il sera capable de *forward* (faire passer) votre requête à un autre serveur DNS qui lui, connaît la réponse.

![Haiku DNS](./pics/haiku_dns.png)

## 2. Setup

🖥️ **Machine `dns-server.tp4.b1`**

- n'oubliez pas de dérouler la checklist (voir [les prérequis du TP](#0-prérequis))
- donnez lui l'adresse IP `10.4.1.201/24`

Installation du serveur DNS :

```bash
# assurez-vous que votre machine est à jour
$ sudo dnf update -y

# installation du serveur DNS, son p'tit nom c'est BIND9
$ sudo dnf install -y bind bind-utils
```

La configuration du serveur DNS va se faire dans 3 fichiers essentiellement :

- **un fichier de configuration principal**
    - `/etc/named.conf`
    - on définit les trucs généraux, comme les adresses IP et le port où on veu écouter
    - on définit aussi un chemin vers les autres fichiers, les fichiers de zone
- **un fichier de zone**
    - `/var/named/tp4.b1.db`
    - je vous préviens, la syntaxe fait mal
    - on peut y définir des correspondances `IP ---> nom`
- **un fichier de zone inverse**
    - `/var/named/tp4.b1.rev`
    - on peut y définir des correspondances `nom ---> IP`

➜ **Allooooons-y, fichier de conf principal**

```bash
# éditez le fichier de config principal pour qu'il ressemble à :
$ sudo cat /etc/named.conf
options {
        listen-on port 53 { 127.0.0.1; any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
[...]
        allow-query     { localhost; any; };
        allow-query-cache { localhost; any; };

        recursion yes;
[...]
# référence vers notre fichier de zone
zone "tp4.b1" IN {
     type master;
     file "tp4.b1.db";
     allow-update { none; };
     allow-query {any; };
};
# référence vers notre fichier de zone inverse
zone "1.4.10.in-addr.arpa" IN {
     type master;
     file "tp4.b1.rev";
     allow-update { none; };
     allow-query { any; };
};
```

➜ **Et pour les fichiers de zone**

```bash
# Fichier de zone pour nom -> IP

$ sudo cat /var/named/tp4.b1.db

$TTL 86400
@ IN SOA dns-server.tp4.b1. admin.tp4.b1. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

; Infos sur le serveur DNS lui même (NS = NameServer)
@ IN NS dns-server.tp4.b1.

; Enregistrements DNS pour faire correspondre des noms à des IPs
dns-server IN A 10.4.1.201
node1      IN A 10.4.1.11
```

```bash
# Fichier de zone inverse pour IP -> nom

$ sudo cat /var/named/tp4.b1.rev

$TTL 86400
@ IN SOA dns-server.tp4.b1. admin.tp4.b1. (
    2019061800 ;Serial
    3600 ;Refresh
    1800 ;Retry
    604800 ;Expire
    86400 ;Minimum TTL
)

; Infos sur le serveur DNS lui même (NS = NameServer)
@ IN NS dns-server.tp4.b1.

;Reverse lookup for Name Server
201 IN PTR dns-server.tp4.b1.
11 IN PTR node1.tp4.b1.
```

➜ **Une fois ces 3 fichiers en place, démarrez le service DNS**

```bash
# Démarrez le service tout de suite
$ sudo systemctl start named

# Faire en sorte que le service démarre tout seul quand la VM s'allume
$ sudo systemctl enable named

# Obtenir des infos sur le service
$ sudo systemctl status named

# Obtenir des logs en cas de probème
$ sudo journalctl -xe -u named
```

🌞 **Dans le rendu, je veux**

- un `cat` des fichiers de conf
- un `systemctl status named` qui prouve que le service tourne bien
- une commande `ss` qui prouve que le service écoute bien sur un port

🌞 **Ouvrez le bon port dans le firewall**

- grâce à la commande `ss` vous devrez avoir repéré sur quel port tourne le service
    - vous l'avez écrit dans la conf aussi toute façon :)
- ouvrez ce port dans le firewall de la machine `dns-server.tp4.b1` (voir le mémo réseau Rocky)

## 3. Test

🌞 **Sur la machine `node1.tp4.b1`**

- configurez la machine pour qu'elle utilise votre serveur DNS quand elle a besoin de résoudre des noms
- assurez vous que vous pouvez :
    - résoudre des noms comme `node1.tp4.b1` et `dns-server.tp4.b1`
    - mais aussi des noms comme `www.google.com`

🌞 **Sur votre PC**

- utilisez une commande pour résoudre le nom `node1.tp4.b1` en utilisant `10.4.1.201` comme serveur DNS

> Le fait que votre serveur DNS puisse résoudre un nom comme `www.google.com`, ça s'appelle la récursivité et c'est activé avec la ligne `recursion yes;` dans le fichier de conf.

🦈 **Capture d'une requête DNS vers le nom `node1.tp4.b1` ainsi que la réponse**