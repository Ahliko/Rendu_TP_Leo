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

☀️ Sur **`node1.lan1.tp1`**

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

```

- prouvez avec un `traceroute` que le paquet passe bien par `router.tp1`

# II. Interlude accès internet

![No internet](./img/no%20internet.jpg)

**On va donner accès internet à tout le monde.** Le routeur aura un accès internet, et permettra à tout le monde d'y accéder : il sera la passerelle par défaut des membres du LAN1 et des membres du LAN2.

**Ajoutez une carte NAT au routeur pour qu'il ait un accès internet.**

☀️ **Sur `router.tp1`**

- prouvez que vous avez un accès internet (ping d'une IP publique)
- prouvez que vous pouvez résoudre des noms publics (ping d'un nom de domaine public)

☀️ **Accès internet LAN1 et LAN2**

- ajoutez une route par défaut sur les deux machines du LAN1
- ajoutez une route par défaut sur les deux machines du LAN2
- configurez l'adresse d'un serveur DNS que vos machines peuvent utiliser pour résoudre des noms
- dans le compte-rendu, mettez-moi que la conf des points précédents sur `node2.lan1.tp1`
- prouvez que `node2.lan1.tp1` a un accès internet :
    - il peut ping une IP publique
    - il peut ping un nom de domaine public

# III. Services réseau

**Adresses IP et routage OK, maintenant, il s'agirait d'en faire quelque chose nan ?**

Dans cette partie, on va **monter quelques services orientés réseau** au sein de la topologie, afin de la rendre un peu utile que diable. Des machines qui se `ping` c'est rigolo mais ça sert à rien, des machines qui font des trucs c'est mieux.

## 1. DHCP

![Dora](./img/dora.jpg)

Petite **install d'un serveur DHCP** dans cette partie. Par soucis d'économie de ressources, on recycle une des machines précédentes : `node2.lan1.tp1` devient `dhcp.lan1.tp1`.

**Pour rappel**, un serveur DHCP, on en trouve un dans la plupart des LANs auxquels vous vous êtes connectés. Si quand tu te connectes dans un réseau, tu n'es pas **obligé** de saisir une IP statique à la mano, et que t'as un accès internet wala, alors il y a **forcément** un serveur DHCP dans le réseau qui t'a proposé une IP disponible.

> Le serveur DHCP a aussi pour rôle de donner, en plus d'une IP disponible, deux informations primordiales pour l'accès internet : l'adresse IP de la passerelle du réseau, et l'adresse d'un serveur DNS joignable depuis ce réseau.

**Dans notre TP, son rôle sera de proposer une IP libre à toute machine qui le demande dans le LAN1.**

> Vous pouvez vous référer à [ce lien](https://www.server-world.info/en/note?os=Rocky_Linux_8&p=dhcp&f=1) ou n'importe quel autre truc sur internet (je sais c'est du Rocky 8, m'enfin, la conf de ce serveur DHCP ça bouge pas trop).

---

Pour ce qui est de la configuration du serveur DHCP, quelques précisions :

- vous ferez en sorte qu'il propose des adresses IPs entre `10.1.1.100` et `10.1.1.200`
- vous utiliserez aussi une option DHCP pour indiquer aux clients que la passerelle du réseau est `10.1.1.254` : le routeur
- vous utiliserez aussi une option DHCP pour indiquer aux clients qu'un serveur DNS joignable depuis le réseau c'est `1.1.1.1`

---

☀️ **Sur `dhcp.lan1.tp1`**

- n'oubliez pas de renommer la machine (`node2.lan1.tp1` devient `dhcp.lan1.tp1`)
- changez son adresse IP en `10.1.1.253`
- setup du serveur DHCP
    - commande d'installation du paquet
    - fichier de conf
    - service actif

☀️ **Sur `node1.lan1.tp1`**

- demandez une IP au serveur DHCP
- prouvez que vous avez bien récupéré une IP *via* le DHCP
- prouvez que vous avez bien récupéré l'IP de la passerelle
- prouvez que vous pouvez `ping node1.lan2.tp1`

## 2. Web web web

Un petit serveur web ? Pour la route ?

On recycle ici, toujours dans un soucis d'économie de ressources, la machine `node2.lan2.tp1` qui devient `web.lan2.tp1`. On va y monter un serveur Web qui mettra à disposition un site web tout nul.

---

La conf du serveur web :

- ce sera notre vieil ami NGINX
- il écoutera sur le port 80, port standard pour du trafic HTTP
- la racine web doit se trouver dans `/var/www/site_nul/`
    - vous y créerez un fichier `/var/www/site_nul/index.html` avec le contenu de votre choix
- vous ajouterez dans la conf NGINX **un fichier dédié** pour servir le site web nul qui se trouve dans `/var/www/site_nul/`
    - écoute sur le port 80
    - répond au nom `site_nul.tp1`
    - sert le dossier `/var/www/site_nul/`
- n'oubliez pas d'ouvrir le port dans le firewall 🌼

---

☀️ **Sur `web.lan2.tp1`**

- n'oubliez pas de renommer la machine (`node2.lan2.tp1` devient `web.lan2.tp1`)
- setup du service Web
    - installation de NGINX
    - gestion de la racine web `/var/www/site_nul/`
    - configuration NGINX
    - service actif
    - ouverture du port firewall
- prouvez qu'il y a un programme NGINX qui tourne derrière le port 80 de la machine (commande `ss`)
- prouvez que le firewall est bien configuré

☀️ **Sur `node1.lan1.tp1`**

- éditez le fichier `hosts` pour que `site_nul.tp1` pointe vers l'IP de `web.lan2.tp1`
- visitez le site nul avec une commande `curl` et en utilisant le nom `site_nul.tp1`

![That's all folks](./img/thatsall.jpg)