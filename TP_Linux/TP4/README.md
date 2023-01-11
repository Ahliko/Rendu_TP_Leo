# Partie 1 : Partitionnement du serveur de stockage

🌞 **Partitionner le disque à l'aide de LVM**

```bash
[ahliko@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for ahliko: 
  Physical volume "/dev/sdb" successfully created.
  
[ahliko@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g

[ahliko@storage ~]$ sudo pvdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  "/dev/sdb" is a new physical volume of "2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name               
  PV Size               2.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               ugr5GQ-CPw3-86K6-hn1Q-Ojtj-hQ4N-itLGkS
```

```bash
[ahliko@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
[ahliko@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize  VFree 
  storage   1   0   0 wz--n- <2.00g <2.00g
[ahliko@storage ~]$ sudo vgdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  --- Volume group ---
  VG Name               storage
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <2.00 GiB
  PE Size               4.00 MiB
  Total PE              511
  Alloc PE / Size       0 / 0   
  Free  PE / Size       511 / <2.00 GiB
  VG UUID               PK96fh-DgMP-2kTS-fZYd-GqRq-TSLF-KM2Zwn
```

```bash
[ahliko@storage ~]$ sudo lvcreate -l 100%FREE storage -n lvstorage
  Logical volume "lvstorage" created.

[ahliko@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  LV        VG      Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvstorage storage -wi-a----- <2.00g                                                    
[ahliko@storage ~]$ sudo lvdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB6f65130d-f645d1d3_ PVID eSLwroXeRGQWCeyeIRpE1nh0Doqc9znZ last seen on /dev/sda2 not found.
  --- Logical volume ---
  LV Path                /dev/storage/lvstorage
  LV Name                lvstorage
  VG Name                storage
  LV UUID                uaLioK-qecN-MrkY-rh3S-QRve-ceRw-bM4ywS
  LV Write Access        read/write
  LV Creation host, time storage.tp4.linux, 2023-01-10 17:05:19 +0100
  LV Status              available
  # open                 0
  LV Size                <2.00 GiB
  Current LE             511
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
```

🌞 **Formater la partition**

```bash
[ahliko@storage ~]$ sudo mkfs -t ext4 /dev/storage/lvstorage
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: d09c0f2e-4234-4b85-9221-f70195c503f3
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done 
```

🌞 **Monter la partition**


```bash
[ahliko@storage ~]$ sudo mkdir /storage
[ahliko@storage ~]$ sudo mount /dev/storage/lvstorage /storage
[ahliko@storage ~]$ df -h | grep /storage
/dev/mapper/storage-lvstorage  2.0G   24K  1.9G   1% /storage
[ahliko@storage ~]$ sudo vim /storage/toto.txt
[sudo] password for ahliko: 
[ahliko@storage ~]$ cat /storage/toto.txt
hey
[ahliko@storage ~]$ sudo umount /storage
[ahliko@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/storage                 : successfully mounted
```


# Partie 2 : Serveur de partage de fichiers

🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**

```bash
[ahliko@storage ~]$ sudo dnf install nfs-utils -y
[ahliko@storage ~]$ sudo mkdir /storage/site_web_1 -p
[ahliko@storage ~]$ sudo mkdir /storage/site_web_2 -p
[ahliko@storage ~]$ sudo chown nobody /storage/site_web_*
[ahliko@storage ~]$ sudo vim /etc/exports
[ahliko@storage ~]$ sudo systemctl start nfs-server

[ahliko@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
     Active: active (exited) since Tue 2023-01-10 17:59:28 CET; 4s ago
    Process: 11643 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 11644 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
    Process: 11663 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)
   Main PID: 11663 (code=exited, status=0/SUCCESS)
        CPU: 17ms

Jan 10 17:59:28 storage.tp4.linux systemd[1]: Starting NFS server and services...
Jan 10 17:59:28 storage.tp4.linux systemd[1]: Finished NFS server and services.


[ahliko@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[ahliko@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[ahliko@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[ahliko@storage ~]$ sudo sudo firewall-cmd --reload
success
[ahliko@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh


[ahliko@storage ~]$ cat /etc/exports
/storage/site_web_1 10.4.0.3(rw,sync,no_subtree_check)
/storage/site_web_2 10.4.0.3(rw,sync,no_subtree_check)


[ahliko@storage ~]$ sudo systemctl enable nfs-server
[sudo] password for ahliko: 
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.


```

🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**


```bash
[ahliko@web ~]$ sudo mkdir -p /var/www/site_web_1
[ahliko@web ~]$ sudo mkdir -p /var/www/site_web_2
[ahliko@web ~]$ ls /var/www
site_web_1  site_web_2

[ahliko@web ~]$ sudo mount 10.4.0.2:/storage/site_web_1 /var/www/site_web_1
[ahliko@web ~]$ sudo mount 10.4.0.2:/storage/site_web_2 /var/www/site_web_2

[ahliko@web ~]$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
devtmpfs                      4.0M     0  4.0M   0% /dev
tmpfs                         3.8G     0  3.8G   0% /dev/shm
tmpfs                         1.6G  8.6M  1.5G   1% /run
/dev/mapper/rl-root           6.2G  1.3G  5.0G  20% /
/dev/sda1                    1014M  299M  716M  30% /boot
tmpfs                         769M     0  769M   0% /run/user/1000
10.4.0.2:/storage/site_web_1  2.0G     0  1.9G   0% /var/www/site_web_1
10.4.0.2:/storage/site_web_2  2.0G     0  1.9G   0% /var/www/site_web_2
```
```bash
[ahliko@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Tue Jan  3 09:18:37 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=0a370dd9-7012-4d29-b16e-96f5cadde8e3 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.4.0.2:/storage/site_web_1    /var/www/site_web_1   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.4.0.2:/storage/site_web_2    /var/www/site_web_2   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

# Partie 3 : Serveur web

- [Partie 3 : Serveur web](#partie-3--serveur-web)
    - [1. Intro NGINX](#1-intro-nginx)
    - [2. Install](#2-install)
    - [3. Analyse](#3-analyse)
    - [4. Visite du service web](#4-visite-du-service-web)
    - [5. Modif de la conf du serveur web](#5-modif-de-la-conf-du-serveur-web)
    - [6. Deux sites web sur un seul serveur](#6-deux-sites-web-sur-un-seul-serveur)

## 1. Intro NGINX

## 2. Install

🖥️ **VM web.tp4.linux**

🌞 **Installez NGINX**

```bash
[ahliko@web ~]$ sudo dnf install nginx -y
```

## 3. Analyse

```bash

[ahliko@web ~]$ sudo systemctl enable nginx
[ahliko@web ~]$ sudo systemctl start nginx
[ahliko@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2023-01-11 17:03:06 CET; 56s ago
    Process: 4379 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 4380 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 4381 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 4382 (nginx)
      Tasks: 3 (limit: 48905)
     Memory: 2.8M
        CPU: 18ms
     CGroup: /system.slice/nginx.service
             ├─4382 "nginx: master process /usr/sbin/nginx"
             ├─4383 "nginx: worker process"
             └─4384 "nginx: worker process"

Jan 11 17:03:06 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 11 17:03:06 web.tp4.linux nginx[4380]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 11 17:03:06 web.tp4.linux nginx[4380]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 11 17:03:06 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

🌞 **Analysez le service NGINX**

```bash
[ahliko@web ~]$ ps -ef | grep nginx
root        4382       1  0 17:03 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4383    4382  0 17:03 ?        00:00:00 nginx: worker process
nginx       4384    4382  0 17:03 ?        00:00:00 nginx: worker process
ahliko      4425    4121  0 17:09 pts/0    00:00:00 grep --color=auto nginx

[sudo] password for ahliko: 
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=4384,fd=6),("nginx",pid=4383,fd=6),("nginx",pid=4382,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=4384,fd=7),("nginx",pid=4383,fd=7),("nginx",pid=4382,fd=7))


[ahliko@web ~]$ cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;

[ahliko@web ~]$ ls -l /usr/share/nginx/html
total 12
-rw-r--r--. 1 root root 3332 Oct 31 16:35 404.html
-rw-r--r--. 1 root root 3404 Oct 31 16:35 50x.html
drwxr-xr-x. 2 root root   27 Jan 11 16:58 icons
lrwxrwxrwx. 1 root root   25 Oct 31 16:37 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 31 16:35 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 31 16:37 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 31 16:37 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

## 4. Visite du service web

🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

```bash
[ahliko@web ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
success

[ahliko@web ~]$ sudo firewall-cmd --reload
success

[ahliko@web ~]$ sudo firewall-cmd --permanent --list-all
public
target: default
icmp-block-inversion: no
interfaces:
sources:
services: cockpit dhcpv6-client ssh
ports: 80/tcp
protocols:
forward: yes
masquerade: no
forward-ports:
source-ports:
icmp-blocks:
rich rules:
```

🌞 **Accéder au site web**

```bash
 ahliko@fedora  ~  curl 10.4.0.3:80
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1); 
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;      
        
      }

   
  h1 {
    text-align: center;
    margin: 0;
    padding: 0.6em 2em 0.4em;
    color: #fff;
    font-weight: bold;
    font-family: 'Montserrat', sans-serif;
    font-size: 2em;
  }
  h1 strong {
    font-weight: bolder;
    font-family: 'Montserrat', sans-serif;
  }
  h2 {
    font-size: 1.5em;
    font-weight:bold;
  }
  
  .title {
    border: 1px solid black;
    font-weight: bold;
    position: relative;
    float: right;
    width: 150px;
    text-align: center;
    padding: 10px 0 10px 0;
    margin-top: 0;
  }
  
  .description {
    padding: 45px 10px 5px 10px;
    clear: right;
    padding: 15px;
  }
  
  .section {
    padding-left: 3%;
   margin-bottom: 10px;
  }
  
  img {
  
    padding: 2px;
    margin: 2px;
  }
  a:hover img {
    padding: 2px;
    margin: 2px;
  }

  :link {
    color: rgb(199, 252, 77);
    text-shadow:
  }
  :visited {
    color: rgb(122, 206, 255);
  }
  a:hover {
    color: rgb(16, 44, 122);
  }
  .row {
    width: 100%;
    padding: 0 10px 0 10px;
  }
  
  footer {
    padding-top: 6em;
    margin-bottom: 6em;
    text-align: center;
    font-size: xx-small;
    overflow:hidden;
    clear: both;
  }
 
  .summary {
    font-size: 140%;
    text-align: center;
  }

  #rocky-poweredby img {
    margin-left: -10px;
  }

  #logos img {
    vertical-align: top;
  }
  
  /* Desktop  View Options */
 
  @media (min-width: 768px)  {
  
    body {
      padding: 10em 20% !important;
    }
    
    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 {
      float: left;
    }
  
    .col-md-1 {
      width: 8.33%;
    }
    .col-md-2 {
      width: 16.66%;
    }
    .col-md-3 {
      width: 25%;
    }
    .col-md-4 {
      width: 33%;
    }
    .col-md-5 {
      width: 41.66%;
    }
    .col-md-6 {
      border-left:3px ;
      width: 50%;
      

    }
    .col-md-7 {
      width: 58.33%;
    }
    .col-md-8 {
      width: 66.66%;
    }
    .col-md-9 {
      width: 74.99%;
    }
    .col-md-10 {
      width: 83.33%;
    }
    .col-md-11 {
      width: 91.66%;
    }
    .col-md-12 {
      width: 100%;
    }
  }
  
  /* Mobile View Options */
  @media (max-width: 767px) {
    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
      float: left;
    }
  
    .col-sm-1 {
      width: 8.33%;
    }
    .col-sm-2 {
      width: 16.66%;
    }
    .col-sm-3 {
      width: 25%;
    }
    .col-sm-4 {
      width: 33%;
    }
    .col-sm-5 {
      width: 41.66%;
    }
    .col-sm-6 {
      width: 50%;
    }
    .col-sm-7 {
      width: 58.33%;
    }
    .col-sm-8 {
      width: 66.66%;
    }
    .col-sm-9 {
      width: 74.99%;
    }
    .col-sm-10 {
      width: 83.33%;
    }
    .col-sm-11 {
      width: 91.66%;
    }
    .col-sm-12 {
      width: 100%;
    }
    h1 {
      padding: 0 !important;
    }
  }
        
  
  </style>
  </head>
  <body>
    <h1>HTTP Server <strong>Test Page</strong></h1>

    <div class='row'>
    
      <div class='col-sm-12 col-md-6 col-md-6 '></div>
          <p class="summary">This page is used to test the proper operation of
            an HTTP server after it has been installed on a Rocky Linux system.
            If you can read this page, it means that the software is working
            correctly.</p>
      </div>
      
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
     
       
        <div class='section'>
          <h2>Just visiting?</h2>

          <p>This website you are visiting is either experiencing problems or
          could be going through maintenance.</p>

          <p>If you would like the let the administrators of this website know
          that you've seen this page instead of the page you've expected, you
          should send them an email. In general, mail sent to the name
          "webmaster" and directed to the website's domain should reach the
          appropriate person.</p>

          <p>The most common email address to send to is:
          <strong>"webmaster@example.com"</strong></p>
    
          <h2>Note:</h2>
          <p>The Rocky Linux distribution is a stable and reproduceable platform
          based on the sources of Red Hat Enterprise Linux (RHEL). With this in
          mind, please understand that:

        <ul>
          <li>Neither the <strong>Rocky Linux Project</strong> nor the
          <strong>Rocky Enterprise Software Foundation</strong> have anything to
          do with this website or its content.</li>
          <li>The Rocky Linux Project nor the <strong>RESF</strong> have
          "hacked" this webserver: This test page is included with the
          distribution.</li>
        </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>
         
          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>
        
        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>       
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>
```

🌞 **Vérifier les logs d'accès**

```bash
[ahliko@web ~]$ sudo cat /var/log/nginx/access.log | tail -n 3
10.4.0.1 - - [11/Jan/2023:17:19:02 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.85.0" "-"
```

## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

```bash
[ahliko@web ~]$ cat /etc/nginx/nginx.conf | grep 8080
        listen       8080;

[ahliko@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[ahliko@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[ahliko@web ~]$ sudo firewall-cmd --reload
success
[ahliko@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 8080/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
  
[ahliko@web ~]$ sudo systemctl restart nginx
[ahliko@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2023-01-11 17:25:52 CET; 8s ago
    Process: 4515 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 4516 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 4518 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 4519 (nginx)
      Tasks: 3 (limit: 48905)
     Memory: 2.8M
        CPU: 18ms
     CGroup: /system.slice/nginx.service
             ├─4519 "nginx: master process /usr/sbin/nginx"
             ├─4520 "nginx: worker process"
             └─4521 "nginx: worker process"

Jan 11 17:25:52 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 11 17:25:52 web.tp4.linux nginx[4516]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 11 17:25:52 web.tp4.linux nginx[4516]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 11 17:25:52 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.

[ahliko@web ~]$ sudo ss -alnpt | grep 8080
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=4521,fd=6),("nginx",pid=4520,fd=6),("nginx",pid=4519,fd=6))


 ahliko@fedora  ~  curl 10.4.0.3:8080
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1); 
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;      
        
      }

   
  h1 {
    text-align: center;
    margin: 0;
    padding: 0.6em 2em 0.4em;
    color: #fff;
    font-weight: bold;
    font-family: 'Montserrat', sans-serif;
    font-size: 2em;
  }
  h1 strong {
    font-weight: bolder;
    font-family: 'Montserrat', sans-serif;
  }
  h2 {
    font-size: 1.5em;
    font-weight:bold;
  }
  
  .title {
    border: 1px solid black;
    font-weight: bold;
    position: relative;
    float: right;
    width: 150px;
    text-align: center;
    padding: 10px 0 10px 0;
    margin-top: 0;
  }
  
  .description {
    padding: 45px 10px 5px 10px;
    clear: right;
    padding: 15px;
  }
  
  .section {
    padding-left: 3%;
   margin-bottom: 10px;
  }
  
  img {
  
    padding: 2px;
    margin: 2px;
  }
  a:hover img {
    padding: 2px;
    margin: 2px;
  }

  :link {
    color: rgb(199, 252, 77);
    text-shadow:
  }
  :visited {
    color: rgb(122, 206, 255);
  }
  a:hover {
    color: rgb(16, 44, 122);
  }
  .row {
    width: 100%;
    padding: 0 10px 0 10px;
  }
  
  footer {
    padding-top: 6em;
    margin-bottom: 6em;
    text-align: center;
    font-size: xx-small;
    overflow:hidden;
    clear: both;
  }
 
  .summary {
    font-size: 140%;
    text-align: center;
  }

  #rocky-poweredby img {
    margin-left: -10px;
  }

  #logos img {
    vertical-align: top;
  }
  
  /* Desktop  View Options */
 
  @media (min-width: 768px)  {
  
    body {
      padding: 10em 20% !important;
    }
    
    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 {
      float: left;
    }
  
    .col-md-1 {
      width: 8.33%;
    }
    .col-md-2 {
      width: 16.66%;
    }
    .col-md-3 {
      width: 25%;
    }
    .col-md-4 {
      width: 33%;
    }
    .col-md-5 {
      width: 41.66%;
    }
    .col-md-6 {
      border-left:3px ;
      width: 50%;
      

    }
    .col-md-7 {
      width: 58.33%;
    }
    .col-md-8 {
      width: 66.66%;
    }
    .col-md-9 {
      width: 74.99%;
    }
    .col-md-10 {
      width: 83.33%;
    }
    .col-md-11 {
      width: 91.66%;
    }
    .col-md-12 {
      width: 100%;
    }
  }
  
  /* Mobile View Options */
  @media (max-width: 767px) {
    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
      float: left;
    }
  
    .col-sm-1 {
      width: 8.33%;
    }
    .col-sm-2 {
      width: 16.66%;
    }
    .col-sm-3 {
      width: 25%;
    }
    .col-sm-4 {
      width: 33%;
    }
    .col-sm-5 {
      width: 41.66%;
    }
    .col-sm-6 {
      width: 50%;
    }
    .col-sm-7 {
      width: 58.33%;
    }
    .col-sm-8 {
      width: 66.66%;
    }
    .col-sm-9 {
      width: 74.99%;
    }
    .col-sm-10 {
      width: 83.33%;
    }
    .col-sm-11 {
      width: 91.66%;
    }
    .col-sm-12 {
      width: 100%;
    }
    h1 {
      padding: 0 !important;
    }
  }
        
  
  </style>
  </head>
  <body>
    <h1>HTTP Server <strong>Test Page</strong></h1>

    <div class='row'>
    
      <div class='col-sm-12 col-md-6 col-md-6 '></div>
          <p class="summary">This page is used to test the proper operation of
            an HTTP server after it has been installed on a Rocky Linux system.
            If you can read this page, it means that the software is working
            correctly.</p>
      </div>
      
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
     
       
        <div class='section'>
          <h2>Just visiting?</h2>

          <p>This website you are visiting is either experiencing problems or
          could be going through maintenance.</p>

          <p>If you would like the let the administrators of this website know
          that you've seen this page instead of the page you've expected, you
          should send them an email. In general, mail sent to the name
          "webmaster" and directed to the website's domain should reach the
          appropriate person.</p>

          <p>The most common email address to send to is:
          <strong>"webmaster@example.com"</strong></p>
    
          <h2>Note:</h2>
          <p>The Rocky Linux distribution is a stable and reproduceable platform
          based on the sources of Red Hat Enterprise Linux (RHEL). With this in
          mind, please understand that:

        <ul>
          <li>Neither the <strong>Rocky Linux Project</strong> nor the
          <strong>Rocky Enterprise Software Foundation</strong> have anything to
          do with this website or its content.</li>
          <li>The Rocky Linux Project nor the <strong>RESF</strong> have
          "hacked" this webserver: This test page is included with the
          distribution.</li>
        </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>
         
          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>
        
        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>       
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>
```

---

🌞 **Changer l'utilisateur qui lance le service**

- pour ça, vous créerez vous-même un nouvel utilisateur sur le système : `web`
    - référez-vous au [mémo des commandes](../../cours/memos/commandes.md) pour la création d'utilisateur
    - l'utilisateur devra avoir un mot de passe, et un homedir défini explicitement à `/home/web`
- modifiez la conf de NGINX pour qu'il soit lancé avec votre nouvel utilisateur
    - utilisez `grep` pour me montrer dans le fichier de conf la ligne que vous avez modifié
- n'oubliez pas de redémarrer le service pour que le changement prenne effet
- vous prouverez avec une commande `ps` que le service tourne bien sous ce nouveau utilisateur
    - utilisez un `| grep` pour isoler les lignes intéressantes

---

**Il est temps d'utiliser ce qu'on a fait à la partie 2 !**

🌞 **Changer l'emplacement de la racine Web**

- configurez NGINX pour qu'il utilise une autre racine web que celle par défaut
    - avec un `nano` ou `vim`, créez un fichiez `/var/www/site_web_1/index.html` avec un contenu texte bidon
    - dans la conf de NGINX, configurez la racine Web sur `/var/www/site_web_1/`
    - vous me montrerez la conf effectuée dans le compte-rendu, avec un `grep`
- n'oubliez pas de redémarrer le service pour que le changement prenne effet
- prouvez avec un `curl` depuis votre hôte que vous accédez bien au nouveau site

> **Normalement le dossier `/var/www/site_web_1/` est un dossier créé à la Partie 2 du TP**, et qui se trouve en réalité sur le serveur `storage.tp4.linux`, notre serveur NFS.

![MAIS](../pics/nop.png)

## 6. Deux sites web sur un seul serveur

Dans la conf NGINX, vous avez du repérer un bloc `server { }` (si c'est pas le cas, allez le repérer, la ligne qui définit la racine web est contenu dans le bloc `server { }`).

Un bloc `server { }` permet d'indiquer à NGINX de servir un site web donné.

Si on veut héberger plusieurs sites web, il faut donc déclarer plusieurs blocs `server { }`.

**Pour éviter que ce soit le GROS BORDEL dans le fichier de conf**, et se retrouver avec un fichier de 150000 lignes, on met chaque bloc `server` dans un fichier de conf dédié.

Et le fichier de conf principal contient une ligne qui inclut tous les fichiers de confs additionnels.

🌞 **Repérez dans le fichier de conf**

- la ligne qui inclut des fichiers additionels contenus dans un dossier nommé `conf.d`
- vous la mettrez en évidence avec un `grep`

> On trouve souvent ce mécanisme dans la conf sous Linux : un dossier qui porte un nom finissant par `.d` qui contient des fichiers de conf additionnels pour pas foutre le bordel dans le fichier de conf principal. On appelle ce dossier un dossier de *drop-in*.

🌞 **Créez le fichier de configuration pour le premier site**

- le bloc `server` du fichier de conf principal, vous le sortez
- et vous le mettez dans un fichier dédié
- ce fichier dédié doit se trouver dans le dossier `conf.d`
- ce fichier dédié doit porter un nom adéquat : `site_web_1.conf`

🌞 **Créez le fichier de configuration pour le deuxième site**

- un nouveau fichier dans le dossier `conf.d`
- il doit porter un nom adéquat : `site_web_2.conf`
- copiez-collez le bloc `server { }` de l'autre fichier de conf
- changez la racine web vers `/var/www/site_web_2/`
- et changez le port d'écoute pour 8888

> N'oubliez pas d'ouvrir le port 8888 dans le firewall. Vous pouvez constater si vous le souhaitez avec un `ss` que NGINX écoute bien sur ce nouveau port.

🌞 **Prouvez que les deux sites sont disponibles**

- depuis votre PC, deux commandes `curl`
- pour choisir quel site visitez, vous choisissez un port spécifique