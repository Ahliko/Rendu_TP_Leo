# Creation d'un VPN
## Somaire
1. [Prérequis](#prerequis)
2. [Installation](#installation)


## Prérequis <a name="prerequis"></a>
Un serveur hébergé chez Digital Ocean avec une IP publique.
Un accès SSH au serveur.

## Installation <a name="installation"></a>

### Creation d'un utilisateur
```bash
$ adduser ahliko --createhome
```
```bash
$ usermod -aG wheel ahliko
```

### Modifier l'accès SSH pour l'utiliser via clé SSH
```bash
$ vim ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+wsSKuLuK2sm2vA6tzJPhzUo2Lol6m+zJDVmdRYfoP6OKMZbs4jt1MeFHwhtsAbjrBDB2qXhIT0aZpLL/lbOWWTLUCKsFIwWFGZLh4yjbFcV1Fyh3NOiHW5s68O2ON0ptzS3m70TE1Yfsx0i3aGwrz2oz+frSiB9UCyJnWIgSyqZVqOO/SHgsanC2PhFtrDYFLawWGRCy4ZaC3b/uJwf9U9D3U3V62qWM97aALgdm6/aJ7pO9xnXwfrjCDQ95Le3w4dzLp+c1Z9qMGASR2GUUWjh9xmeNc10J9S8PKzjXJJN/Hpp9ZdTkkdihXRm4AzCHIKQqXOnzyX4HUMsv9Eu9jEjwH6Cw22EX/U/z8xFwPgNEKATLwOQKiThK7XEQS7lfDtPkoZxm2ZO+ZjKgxkknlbHwMTYHeQ277il4eLN7dFY957tiWIyiAo8gUZstO9SfuL+oyaXFNw9X2s0wCjQu2mXcwZY7LlaA2aOqhf+RjaWyftrY+vJxkyyrDjZZmRs= ahliko@ahliko-pc
```
```bash
$ chmod 600 ~/.ssh/authorized_keys
```
```bash
$ chown ahliko:ahliko ~/.ssh
$ chown ahliko:ahliko ~/.ssh/*
```

### SSH Server Hardening
```bash
$ vim /etc/ssh/sshd_config
#################
#               #
#   Hardening   #
#               #
#################

ChallengeResponseAuthentication no

### Temporarily enabled to check IPs of possibly attackers
PasswordAuthentication yes
###

IgnoreRhosts yes
MaxAuthTries 3
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
#MACs hmac-sha2-512-etm@openssh.com
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
#KexAlgorithms=curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
RekeyLimit 256M
#ServerKeyBits 2048 # Deprecated
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
PasswordAuthentication no
KerberosAuthentication no
HostbasedAuthentication no
ChallengeResponseAuthentication no
```

### Installation de Wireguard
```bash
$ sudo dnf install elrepo-release epel-release -y
``` 
```bash
$ sudo dnf install kmod-wireguard wireguard-tools -y
```

#### Configuration des clés
```bash
$ wg genkey | sudo tee /etc/wireguard/private.key
UDzMl/aCCVuCkHRIzbRuC2WSS9i7tpSx0AhsNH1dlFQ=
```
```bash
$ sudo chmod go= /etc/wireguard/private.key
```

```bash
$ sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
wd3NAVdzFmATpwBLyxR5PtJRaDJ6Ugsr0hLfo0PmNyw=
```

#### Choix des IPs

IPv4 : `10.8.0.0/24`

#### Configuration du serveur
```bash
$ sudo vim /etc/wireguard/wg0.conf
[Interface]
PrivateKey = UDzMl/aCCVuCkHRIzbRuC2WSS9i7tpSx0AhsNH1dlFQ=
Address = 10.8.0.1/24
ListenPort = 51820
SaveConfig = true
```

#### Configuration Internet du serveur
```bash
$ sudo vi /etc/sysctl.conf
net.ipv4.ip_forward = 1
```
```bash
$ sudo sysctl -p
net.ipv4.ip_forward = 1
```

#### Configuration du pare-feu
```bash
$ sudo dnf install firewalld -y
```
```bash
$ sudo systemctl enable firewalld
```
```bash
$ sudo systemctl start firewalld
```
```bash
$ sudo firewall-cmd --zone=public --add-port=51820/udp --permanent
```
```bash
$ sudo firewall-cmd --zone=internal --add-interface=wg0 --permanent
```
```bash
sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address=10.8.0.0/24 masquerade' --permanent
```
```bash
$ sudo firewall-cmd --reload
```
```bash
$ sudo firewall-cmd --zone=public --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth1
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 51820/udp
  protocols: 
  forward: no
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
        rule family="ipv4" source address="10.8.0.0/24" masquerade
```

```bash
sudo firewall-cmd --zone=internal --list-interfaces
wg0
```

#### Activation du service
```bash
$ sudo systemctl enable wg-quick@wg0
```
```bash
$ sudo systemctl start wg-quick@wg0
```

```bash
$ sudo systemctl status wg-quick@wg0.service
● wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0
   Loaded: loaded (/usr/lib/systemd/system/wg-quick@.service; enabled; vendor preset: disabled)
   Active: active (exited) since Tue 2022-11-08 11:32:13 UTC; 44s ago
     Docs: man:wg-quick(8)
           man:wg(8)
           https://www.wireguard.com/
           https://www.wireguard.com/quickstart/
           https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8
           https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8
  Process: 15829 ExecStart=/usr/bin/wg-quick up wg0 (code=exited, status=0/SUCCESS)
 Main PID: 15829 (code=exited, status=0/SUCCESS)

Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 systemd[1]: Starting WireGuard via wg-quick(8) for wg0...
Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 wg-quick[15829]: [#] ip link add wg0 type wireguard
Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 wg-quick[15829]: [#] wg setconf wg0 /dev/fd/63
Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 wg-quick[15829]: [#] ip -4 address add 10.8.0.1/24 dev wg0
Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 wg-quick[15829]: [#] ip link set mtu 1420 up dev wg0
Nov 08 11:32:13 rockylinux-s-1vcpu-512mb-10gb-ams3-01 systemd[1]: Started WireGuard via wg-quick(8) for wg0.
```
