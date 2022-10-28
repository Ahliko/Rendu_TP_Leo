# TP4 : TCP, UDP et services réseau

# Sommaire

- [TP4 : TCP, UDP et services réseau](#tp4--tcp-udp-et-services-réseau)
- [Sommaire](#sommaire)
- [I. First steps](#i-first-steps)
- [II. Mise en place](#ii-mise-en-place)
    - [1. SSH](#1-ssh)
- [III. DNS](#iii-dns)
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

```bash
 ahliko@ahliko-pc ~ $ ss -tpun
Netid   State        Recv-Q   Send-Q           Local Address:Port             Peer Address:Port    Process                                   
udp     ESTAB        0        0          10.33.16.229%wlp4s0:68               10.33.19.254:67                                                
tcp     ESTAB        0        0                    127.0.0.1:40206               127.0.0.1:63342    users:(("jcef_helper",pid=4985,fd=28))   
tcp     ESTAB        0        0                 10.33.16.229:38938           136.243.137.2:443                                               
tcp     CLOSE-WAIT   25       0                 10.33.16.229:48346           82.145.216.20:443      users:(("opera",pid=3614,fd=29))         
tcp     ESTAB        0        0                 10.33.16.229:60326          74.125.206.188:5228     users:(("opera",pid=3614,fd=25))         
tcp     ESTAB        0        0                 10.33.16.229:60830         192.241.190.146:443      users:(("opera",pid=3614,fd=55))         
tcp     ESTAB        0        0                     10.4.1.1:60002               10.4.1.11:22       users:(("ssh",pid=7499,fd=3))            
tcp     ESTAB        0        0                    127.0.0.1:56418               127.0.0.1:63342    users:(("jcef_helper",pid=4985,fd=25))   
tcp     ESTAB        0        0                 10.33.16.229:35410           140.82.114.26:443      users:(("opera",pid=3614,fd=83))         
tcp     ESTAB        0        0           [::ffff:127.0.0.1]:63342      [::ffff:127.0.0.1]:56418    users:(("java",pid=4792,fd=52))          
tcp     ESTAB        0        0           [::ffff:127.0.0.1]:63342      [::ffff:127.0.0.1]:40206    users:(("java",pid=4792,fd=329)) 
```

# III. DNS

## 2. Setup

🌞 **Dans le rendu, je veux**

```bash
[ahliko@dns-server ~]$ sudo cat /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
        listen-on port 53 { 127.0.0.1; any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { localhost; any; };
        allow-query-cache { localhost; any; };
        /* 
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable 
           recursion. 
         - If your recursive DNS server has a public IP address, you MUST enable access 
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification 
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface 
        */
        recursion yes;

        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};
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

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

```bash
[ahliko@dns-server ~]$ sudo cat /var/named/tp4.b1.db
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
[ahliko@dns-server ~]$ sudo !!
sudo cat /var/named/tp4.b1.rev
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

```bash
[ahliko@dns-server ~]$ sudo systemctl status named
● named.service - Berkeley Internet Name Domain (DNS)
     Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
     Active: active (running) since Fri 2022-10-28 15:39:11 CEST; 11s ago
   Main PID: 1464 (named)
      Tasks: 4 (limit: 5906)
     Memory: 16.5M
        CPU: 47ms
     CGroup: /system.slice/named.service
             └─1464 /usr/sbin/named -u named -c /etc/named.conf

Oct 28 15:39:11 dns-server.tp4.b1 named[1464]: network unreachable resolving './NS/IN': 2001:500:9f::42#53
Oct 28 15:39:11 dns-server.tp4.b1 named[1464]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa/IN: loaded seri>
Oct 28 15:39:11 dns-server.tp4.b1 named[1464]: zone localhost.localdomain/IN: loaded serial 0
Oct 28 15:39:11 dns-server.tp4.b1 named[1464]: all zones loaded
Oct 28 15:39:11 dns-server.tp4.b1 systemd[1]: Started Berkeley Internet Name Domain (DNS).
Oct 28 15:39:11 dns-server.tp4.b1 named[1464]: running
```

```bash
[ahliko@dns-server ~]$ sudo ss -punl
State        Recv-Q       Send-Q             Local Address:Port              Peer Address:Port       Process                                 
UNCONN       0            0                     10.4.1.201:53                     0.0.0.0:*           users:(("named",pid=1464,fd=19))       
UNCONN       0            0                      127.0.0.1:53                     0.0.0.0:*           users:(("named",pid=1464,fd=16))       
UNCONN       0            0                      127.0.0.1:323                    0.0.0.0:*           users:(("chronyd",pid=658,fd=5))       
UNCONN       0            0                          [::1]:53                        [::]:*           users:(("named",pid=1464,fd=22))       
UNCONN       0            0                          [::1]:323                       [::]:*           users:(("chronyd",pid=658,fd=6))       
```

🌞 **Ouvrez le bon port dans le firewall**

```bash
[ahliko@dns-server ~]$ sudo firewall-cmd --add-port=53/udp --permanent
success
[ahliko@dns-server ~]$ sudo firewall-cmd --reload
success
```

## 3. Test

🌞 **Sur la machine `node1.tp4.b1`**

```bash
[ahliko@node1 ~]$ cat /etc/resolv.conf
# Generated by NetworkManager
search tp4.b1
nameserver 10.4.1.201
```
```bash
[ahliko@node1 ~]$ dig node1.tp4.b1 @10.4.1.201

; <<>> DiG 9.16.23-RH <<>> node1.tp4.b1 @10.4.1.201
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19844
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 64c28e3499ef750701000000635be3527590d4d6ed115cda (good)
;; QUESTION SECTION:
;node1.tp4.b1.                  IN      A

;; ANSWER SECTION:
node1.tp4.b1.           86400   IN      A       10.4.1.11

;; Query time: 0 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Fri Oct 28 16:12:34 CEST 2022
;; MSG SIZE  rcvd: 85
```
```bash
[ahliko@node1 ~]$ dig dns-server.tp4.b1

; <<>> DiG 9.16.23-RH <<>> dns-server.tp4.b1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20188
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: c0f3047bcd9bb62301000000635be3afb307a4bbf759e93a (good)
;; QUESTION SECTION:
;dns-server.tp4.b1.             IN      A

;; ANSWER SECTION:
dns-server.tp4.b1.      86400   IN      A       10.4.1.201

;; Query time: 0 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Fri Oct 28 16:14:07 CEST 2022
;; MSG SIZE  rcvd: 90
```

```bash
[ahliko@node1 ~]$ dig www.google.com

; <<>> DiG 9.16.23-RH <<>> www.google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54727
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 1651afc3a448a17401000000635be3d00b0f0069402afedb (good)
;; QUESTION SECTION:
;www.google.com.                        IN      A

;; ANSWER SECTION:
www.google.com.         300     IN      A       142.250.179.100

;; Query time: 875 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Fri Oct 28 16:14:40 CEST 2022
;; MSG SIZE  rcvd: 87
```

🌞 **Sur votre PC**
```bash
ahliko@ahliko-pc ~/Ynov/Rendu_TP_Leo/TP4 $ dig node1.tp4.b1 @10.4.1.201   

; <<>> DiG 9.16.33-RH <<>> node1.tp4.b1 @10.4.1.201
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14207
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 8648586ee37c985301000000635be45cb60e0a82e73e4d2b (good)
;; QUESTION SECTION:
;node1.tp4.b1.                  IN      A

;; ANSWER SECTION:
node1.tp4.b1.           86400   IN      A       10.4.1.11

;; Query time: 0 msec
;; SERVER: 10.4.1.201#53(10.4.1.201)
;; WHEN: Fri Oct 28 16:17:00 CEST 2022
;; MSG SIZE  rcvd: 85
```