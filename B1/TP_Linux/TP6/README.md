# Module 1 : Reverse Proxy

## Sommaire

- [Module 1 : Reverse Proxy](#module-1--reverse-proxy)
    - [Sommaire](#sommaire)
- [I. Setup](#i-setup)
- [II. HTTPS](#ii-https)

# I. Setup

🌞 **On utilisera NGINX comme reverse proxy**

```bash
[ahliko@proxy ~]$ sudo dnf install nginx -y
[ahliko@proxy ~]$ sudo systemctl start nginx
[ahliko@proxy ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
[ahliko@proxy ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-01-31 11:23:03 CET; 26s ago
   Main PID: 4228 (nginx)
      Tasks: 3 (limit: 48900)
     Memory: 2.8M
        CPU: 12ms
     CGroup: /system.slice/nginx.service
             ├─4228 "nginx: master process /usr/sbin/nginx"
             ├─4229 "nginx: worker process"
             └─4230 "nginx: worker process"

Jan 31 11:23:03 proxy.tp6.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 31 11:23:03 proxy.tp6.linux nginx[4226]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 31 11:23:03 proxy.tp6.linux nginx[4226]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 31 11:23:03 proxy.tp6.linux systemd[1]: Started The nginx HTTP and reverse proxy server.

[ahliko@proxy ~]$ sudo ss -alpnt | grep -i nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=4230,fd=6),("nginx",pid=4229,fd=6),("nginx",pid=4228,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=4230,fd=7),("nginx",pid=4229,fd=7),("nginx",pid=4228,fd=7))

[ahliko@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[ahliko@proxy ~]$ sudo firewall-cmd --reload
success

[ahliko@proxy ~]$ ps -ef | grep -i nginx
root        4228       1  0 11:23 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4229    4228  0 11:23 ?        00:00:00 nginx: worker process
nginx       4230    4228  0 11:23 ?        00:00:00 nginx: worker process
ahliko      4281    4059  0 11:25 pts/0    00:00:00 grep --color=auto -i nginx

 ahliko@fedora  ~  curl 10.105.1.13
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

🌞 **Configurer NGINX**

```bash
[ahliko@proxy ~]$ cat /etc/nginx/nginx.conf | grep -i include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;

[ahliko@proxy ~]$ cat /etc/nginx/conf.d/proxy.conf
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}

[ahliko@web ~]$ sudo cat /var/www/tp6_nextcloud/config/config.php
<?php
$CONFIG = array (
  'instanceid' => 'oc0osczckf2e',
  'passwordsalt' => 'YqHn9u7cpzNLrnyo27jKXP0r/uqcs1',
  'secret' => 'x5IY3Ohr058bHDEZZV7aYqrxU70dlCkNQjLqFBGwl2GWk1KD',
  'trusted_domains' => 
  array (
	  0 => 'web.tp6.linux',
	  1 => 'www.nextcloud.tp6',
  ),
  'datadirectory' => '/var/www/tp6_nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '25.0.0.15',
  'overwrite.cli.url' => 'http://web.tp6.linux',
  'dbname' => 'nextcloud',
  'dbhost' => '10.105.1.12',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'pewpewpew',
  'installed' => true,
);

[ahliko@proxy ~]$ sudo systemctl restart nginx
[ahliko@proxy ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-01-31 11:42:39 CET; 15s ago
    Process: 4312 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 4313 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 4314 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 4315 (nginx)
      Tasks: 3 (limit: 48900)
     Memory: 2.9M
        CPU: 13ms
     CGroup: /system.slice/nginx.service
             ├─4315 "nginx: master process /usr/sbin/nginx"
             ├─4316 "nginx: worker process"
             └─4317 "nginx: worker process"

Jan 31 11:42:39 proxy.tp6.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 31 11:42:39 proxy.tp6.linux nginx[4313]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 31 11:42:39 proxy.tp6.linux nginx[4313]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 31 11:42:39 proxy.tp6.linux systemd[1]: Started The nginx HTTP and reverse proxy server.

[ahliko@web ~]$ sudo systemctl restart httpd
[ahliko@web ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/httpd.service.d
             └─php81-php-fpm.conf
     Active: active (running) since Tue 2023-01-31 11:43:24 CET; 11s ago
       Docs: man:httpd.service(8)
   Main PID: 1738 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 48905)
     Memory: 28.9M
        CPU: 40ms
     CGroup: /system.slice/httpd.service
             ├─1738 /usr/sbin/httpd -DFOREGROUND
             ├─1739 /usr/sbin/httpd -DFOREGROUND
             ├─1740 /usr/sbin/httpd -DFOREGROUND
             ├─1741 /usr/sbin/httpd -DFOREGROUND
             └─1742 /usr/sbin/httpd -DFOREGROUND

Jan 31 11:43:24 web.tp6.linux systemd[1]: Starting The Apache HTTP Server...
Jan 31 11:43:24 web.tp6.linux httpd[1738]: Server configured, listening on: port 80
Jan 31 11:43:24 web.tp6.linux systemd[1]: Started The Apache HTTP Server.
```

🌞 **Faites en sorte de**

```bash
[ahliko@web ~]$ sudo firewall-cmd --set-default-zone drop
success
[ahliko@web ~]$ sudo firewall-cmd --get-default-zone
drop
[ahliko@web ~]$ sudo firewall-cmd --add-source=10.105.1.13 --permanent
success
[ahliko@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[ahliko@web ~]$ sudo firewall-cmd --reload
success
[ahliko@web ~]$ sudo firewall-cmd --list-all
drop (active)
  target: DROP
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 10.105.1.13
  services: 
  ports: 80/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

[ahliko@web ~]$ cat /etc/httpd/conf/httpd.conf | grep -i listen
Listen 80
[ahliko@web ~]$ sudo systemctl restart httpd
[ahliko@web ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/httpd.service.d
             └─php81-php-fpm.conf
     Active: active (running) since Tue 2023-01-31 12:35:34 CET; 55s ago
       Docs: man:httpd.service(8)
   Main PID: 1644 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 48905)
     Memory: 27.0M
        CPU: 72ms
     CGroup: /system.slice/httpd.service
             ├─1644 /usr/sbin/httpd -DFOREGROUND
             ├─1645 /usr/sbin/httpd -DFOREGROUND
             ├─1646 /usr/sbin/httpd -DFOREGROUND
             ├─1647 /usr/sbin/httpd -DFOREGROUND
             └─1648 /usr/sbin/httpd -DFOREGROUND

Jan 31 12:35:14 web.tp6.linux systemd[1]: Starting The Apache HTTP Server...
Jan 31 12:35:34 web.tp6.linux systemd[1]: Started The Apache HTTP Server.
Jan 31 12:35:34 web.tp6.linux httpd[1644]: Server configured, listening on: port 80



[ahliko@proxy ~]$ sudo firewall-cmd --list-all
[sudo] password for ahliko: 
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
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

🌞 **Une fois que c'est en place**

```bash
 ahliko@fedora  ~  ping 10.105.1.11
PING 10.105.1.11 (10.105.1.11) 56(84) octets de données.
^C
--- statistiques ping 10.105.1.11 ---
4 paquets transmis, 0 reçus, 100% packet loss, time 3060ms

 ✘ ahliko@fedora  ~  ping 10.105.1.13
PING 10.105.1.13 (10.105.1.13) 56(84) octets de données.
64 octets de 10.105.1.13 : icmp_seq=1 ttl=64 temps=0.544 ms
64 octets de 10.105.1.13 : icmp_seq=2 ttl=64 temps=0.270 ms
^C
--- statistiques ping 10.105.1.13 ---
2 paquets transmis, 2 reçus, 0% packet loss, time 1037ms
rtt min/avg/max/mdev = 0.270/0.407/0.544/0.137 ms
```

# II. HTTPS

Le but de cette section est de permettre une connexion chiffrée lorsqu'un client se connecte. Avoir le ptit HTTPS :)

Le principe :

- on génère une paire de clés sur le serveur `proxy.tp6.linux`
    - une des deux clés sera la clé privée : elle restera sur le serveur et ne bougera jamais
    - l'autre est la clé publique : elle sera stockée dans un fichier appelé *certificat*
        - le *certificat* est donné à chaque client qui se connecte au site
- on ajuste la conf NGINX
    - on lui indique le chemin vers le certificat et la clé privée afin qu'il puisse les utiliser pour chiffrer le trafic
    - on lui demande d'écouter sur le port convetionnel pour HTTPS : 443 en TCP

Je vous laisse Google vous-mêmes "nginx reverse proxy nextcloud" ou ce genre de chose :)

🌞 **Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP**

```bash
[ahliko@proxy ~]$ sudo firewall-cmd --remove-port=80/tcp
success
[ahliko@proxy ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[ahliko@proxy ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[ahliko@proxy ~]$ sudo firewall-cmd --reload
success
[ahliko@proxy ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 443/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

[ahliko@proxy ~]$ ls -al /etc/nginx/
total 92
drwxr-xr-x.  4 root   root   4096 Jan 31 13:32 .
drwxr-xr-x. 77 root   root   8192 Jan 31 12:10 ..
drwxr-xr-x.  2 root   root     24 Jan 31 13:32 conf.d
drwxr-xr-x.  2 root   root      6 Oct 31 16:37 default.d
-rw-r--r--.  1 root   root   1077 Oct 31 16:37 fastcgi.conf
-rw-r--r--.  1 root   root   1077 Oct 31 16:37 fastcgi.conf.default
-rw-r--r--.  1 root   root   1007 Oct 31 16:37 fastcgi_params
-rw-r--r--.  1 root   root   1007 Oct 31 16:37 fastcgi_params.default
-rw-r--r--.  1 root   root   2837 Oct 31 16:37 koi-utf
-rw-r--r--.  1 root   root   2223 Oct 31 16:37 koi-win
-rw-r--r--.  1 root   root   5231 Oct 31 16:37 mime.types
-rw-r--r--.  1 root   root   5231 Oct 31 16:37 mime.types.default
-rw-r--r--.  1 root   root   1135 Jan 31 12:55 nginx.conf
-rw-r--r--.  1 root   root   2656 Oct 31 16:37 nginx.conf.default
-rw-r--r--.  1 root   root    636 Oct 31 16:37 scgi_params
-rw-r--r--.  1 root   root    636 Oct 31 16:37 scgi_params.default
-rw-r--r--.  1 root   root    664 Oct 31 16:37 uwsgi_params
-rw-r--r--.  1 root   root    664 Oct 31 16:37 uwsgi_params.default
-rw-r--r--.  1 root   root   3610 Oct 31 16:37 win-utf
-rw-r--r--.  1 ahliko ahliko 1359 Jan 31 13:11 www.nextcloud.tp6.crt
-rw-------.  1 ahliko ahliko 1704 Jan 31 13:08 www.nextcloud.tp6.key

[ahliko@proxy ~]$ cat /etc/nginx/conf.d/proxy.conf 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name www.nextcloud.tp6;

    # Port d'écoute de NGINX
    listen 443 ssl;
    ssl_certificate     www.nextcloud.tp6.crt;
    ssl_certificate_key www.nextcloud.tp6.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}

[ahliko@proxy ~]$ sudo systemctl restart nginx
[ahliko@proxy ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-01-31 13:33:44 CET; 10s ago
    Process: 1484 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1485 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1486 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1487 (nginx)
      Tasks: 3 (limit: 48900)
     Memory: 3.5M
        CPU: 18ms
     CGroup: /system.slice/nginx.service
             ├─1487 "nginx: master process /usr/sbin/nginx"
             ├─1488 "nginx: worker process"
             └─1489 "nginx: worker process"

Jan 31 13:33:44 proxy.tp6.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 31 13:33:44 proxy.tp6.linux nginx[1485]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 31 13:33:44 proxy.tp6.linux nginx[1485]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 31 13:33:44 proxy.tp6.linux systemd[1]: Started The nginx HTTP and reverse proxy server.

 ✘ ahliko@fedora  ~  curl https://www.nextcloud.tp6 -k -v 
*   Trying 10.105.1.13:443...
* Connected to www.nextcloud.tp6 (10.105.1.13) port 443 (#0)
* ALPN: offers h2
* ALPN: offers http/1.1
* TLSv1.0 (OUT), TLS header, Certificate Status (22):
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS header, Finished (20):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS header, Finished (20):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN: server accepted http/1.1
* Server certificate:
*  subject: C=FR; ST=France; L=Default City; O=Default Company Ltd; CN=www.nextcloud.tp6
*  start date: Jan 31 12:11:40 2023 GMT
*  expire date: Jan 31 12:11:40 2024 GMT
*  issuer: C=FR; ST=France; L=Default City; O=Default Company Ltd; CN=www.nextcloud.tp6
*  SSL certificate verify result: self-signed certificate (18), continuing anyway.
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
> GET / HTTP/1.1
> Host: www.nextcloud.tp6
> User-Agent: curl/7.85.0
> Accept: */*
> 
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.20.1
< Date: Tue, 31 Jan 2023 12:41:09 GMT
< Content-Type: text/html; charset=UTF-8
< Content-Length: 156
< Connection: keep-alive
< Last-Modified: Thu, 06 Oct 2022 12:42:47 GMT
< ETag: "9c-5ea5d07c89fc0"
< Accept-Ranges: bytes
< 
<!DOCTYPE html>
<html>
<head>
	<script> window.location.href="index.php"; </script>
	<meta http-equiv="refresh" content="0; URL=index.php">
</head>
</html>
* Connection #0 to host www.nextcloud.tp6 left intact
```

# Module 2 : Sauvegarde du système de fichiers

## Sommaire

- [Module 2 : Sauvegarde du système de fichiers](#module-2--sauvegarde-du-système-de-fichiers)
  - [Sommaire](#sommaire)
  - [I. Script de backup](#i-script-de-backup)
    - [1. Ecriture du script](#1-ecriture-du-script)
    - [2. Clean it](#2-clean-it)
    - [3. Service et timer](#3-service-et-timer)
  - [II. NFS](#ii-nfs)
    - [1. Serveur NFS](#1-serveur-nfs)
    - [2. Client NFS](#2-client-nfs)

## I. Script de backup

### 1. Ecriture du script

🌞 **Ecrire le script `bash`**

```bash
[ahliko@web tp5_nextcloud]$ cat /srv/tp6_backup.sh
#!/bin/bash
# -----------------------------------
# 31/01/2023
# Script written by Killian Guillemot
# V1.0
# -----------------------------------
# Script for backup nextcloud's data

/usr/bin/php81 /var/www/tp5_nextcloud/occ maintenance:mode --on

backup_root="/srv/backup/"
backup_ext=".tar.gz"
date_now=$(date +"%Y%m%d")

nc_root="/var/www/tp5_nextcloud/"
nc_conf="${nc_root}/config/"
nc_data="${nc_root}/data/"
nc_themes="${nc_root}/themes/"

tar -czvf "${backup_root}/nextcloud_${date_now}${backup_ext}" "${nc_conf}" "${nc_data}" "${nc_themes}"

/usr/bin/php81 /var/www/tp5_nextcloud/occ maintenance:mode --off
```

### 2. Clean it

```bash
[ahliko@web ~]$ sudo useradd backup -m -d /srv/backup -s /usr/sbin/nologin
[ahliko@web ~]$ sudo passwd backup
[ahliko@web ~]$ sudo usermod -aG wheel backup
[ahliko@web ~]$ sudo chown backup:backup -R /srv/backup
[ahliko@web ~]$ sudo chown backup:backup -R /srv/tp6_backup.sh
[ahliko@web ~]$ ls -al /srv
total 4
drwxr-xr-x.  3 root   root    41 Jan 31 14:24 .
dr-xr-xr-x. 18 root   root   235 Jan 31 14:16 ..
drwxr-xr-x.  2 backup backup   6 Jan 31 14:00 backup
-rw-r--r--.  1 backup backup 604 Jan 31 14:24 tp6_backup.sh

```

```bash
[ahliko@web tp5_nextcloud]$ sudo -u backup sudo bash /srv/tp6_backup.sh
The current PHP memory limit is below the recommended value of 512MB.
Maintenance mode enabled
tar: Removing leading `/' from member names
/var/www/tp5_nextcloud//config/
/var/www/tp5_nextcloud//config/config.sample.php
tar: Removing leading `/' from hard link targets
/var/www/tp5_nextcloud//config/.htaccess
/var/www/tp5_nextcloud//config/config.php
/var/www/tp5_nextcloud//data/
/var/www/tp5_nextcloud//data/.htaccess
/var/www/tp5_nextcloud//data/index.html
/var/www/tp5_nextcloud//data/nextcloud.log
/var/www/tp5_nextcloud//data/.ocdata
/var/www/tp5_nextcloud//data/ahliko/
/var/www/tp5_nextcloud//data/ahliko/files/
/var/www/tp5_nextcloud//data/ahliko/files/Documents/
/var/www/tp5_nextcloud//data/ahliko/files/Documents/Nextcloud flyer.pdf
/var/www/tp5_nextcloud//data/ahliko/files/Documents/Example.md
/var/www/tp5_nextcloud//data/ahliko/files/Documents/Welcome to Nextcloud Hub.docx
/var/www/tp5_nextcloud//data/ahliko/files/Documents/Readme.md
/var/www/tp5_nextcloud//data/ahliko/files/Nextcloud Manual.pdf
/var/www/tp5_nextcloud//data/ahliko/files/Nextcloud.png
/var/www/tp5_nextcloud//data/ahliko/files/Reasons to use Nextcloud.pdf
/var/www/tp5_nextcloud//data/ahliko/files/Nextcloud intro.mp4
/var/www/tp5_nextcloud//data/ahliko/files/Photos/
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Frog.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Nextcloud community.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Library.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Birdie.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Toucan.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Vineyard.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Steps.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Readme.md
/var/www/tp5_nextcloud//data/ahliko/files/Photos/Gorilla.jpg
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Org chart.odg
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Product plan.md
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Letter.odt
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Meeting notes.md
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Mindmap.odg
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Elegant.odp
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/SWOT analysis.whiteboard
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Expense report.ods
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Simple.odp
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Invoice.odt
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Flowchart.odg
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Business model canvas.odg
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Impact effort matrix.whiteboard
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Diagram & table.ods
/var/www/tp5_nextcloud//data/ahliko/files/Modèles/Readme.md
/var/www/tp5_nextcloud//data/ahliko/cache/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/core/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/core/merged-template-prepend.js
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/core/merged-template-prepend.js.deps
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/core/merged-template-prepend.js.gzip
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/files/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/files/merged-index.js
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/files/merged-index.js.deps
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/js/files/merged-index.js.gzip
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/appstore/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/appstore/apps.json
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/ahliko/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/ahliko/avatar.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/ahliko/generated
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/ahliko/avatar.64.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/avatar/ahliko/avatar-dark.64.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/2/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/2/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/2/f/18/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/2/f/18/236-255-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/f/4/9/2/2/f/18/236-236-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/3/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/3/f/32/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/3/f/32/1600-1067-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/3/6/4/d/3/f/32/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/b/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/b/1/29/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/b/1/29/1600-1067-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/6/e/a/9/a/b/1/29/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/d/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/d/a/19/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/d/a/19/256-144-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/f/0/e/3/d/a/19/144-144-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/4/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/4/e/36/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/4/e/36/4096-4096-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/9/c/a/1/4/e/36/1024-1024-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/0/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/0/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/0/c/33/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/0/c/33/1600-1067-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/8/2/b/e/0/c/33/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/c/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/c/d/35/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/c/d/35/1200-1800-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/1/c/3/8/3/c/d/35/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/7/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/7/b/16/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/7/b/16/256-144-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/7/4/d/9/7/b/16/144-144-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/3/2/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/3/2/31/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/3/2/31/1600-1066-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/c/1/6/a/5/3/2/31/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/7/0/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/7/0/20/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/7/0/20/181-256-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/8/f/1/3/7/0/20/181-181-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/c/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/c/7/15/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/c/7/15/256-181-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/b/f/3/1/c/7/15/181-181-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/9/500-500-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/c/0/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/c/0/21/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/c/0/21/181-256-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/c/5/9/d/c/0/21/181-181-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/c/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/c/b/30/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/c/b/30/3000-2000-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/3/4/1/7/3/c/b/30/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/9/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/9/e/37/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/9/e/37/1600-1067-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/a/5/b/f/c/9/e/37/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/5/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/5/3/34/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/5/3/34/1920-1281-max.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/3/6/9/8/5/3/34/1024-1024-crop.jpg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/b/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/b/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/b/7/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/b/7/5/4096-4096-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/e/4/d/a/3/b/7/5/1024-1024-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/4/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/4/5/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/4/5/7/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/4/5/7/4096-4096-max.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/preview/8/f/1/4/e/4/5/7/1024-1024-crop.png
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/108/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/108/icon-core-filetypes_x-office-document.svg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/108/icon-core-filetypes_file.svg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/108/icon-core-filetypes_x-office-presentation.svg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/theming/108/icon-core-filetypes_x-office-drawing.svg
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/text/
/var/www/tp5_nextcloud//data/appdata_oc0osczckf2e/text/documents/
/var/www/tp5_nextcloud//data/files_external/
/var/www/tp5_nextcloud//data/files_external/rootcerts.crt
/var/www/tp5_nextcloud//themes/
/var/www/tp5_nextcloud//themes/example/
/var/www/tp5_nextcloud//themes/example/core/
/var/www/tp5_nextcloud//themes/example/core/img/
/var/www/tp5_nextcloud//themes/example/core/img/favicon.svg
/var/www/tp5_nextcloud//themes/example/core/img/logo.png
/var/www/tp5_nextcloud//themes/example/core/img/favicon-touch.png
/var/www/tp5_nextcloud//themes/example/core/img/logo-icon.png
/var/www/tp5_nextcloud//themes/example/core/img/logo-mail.gif
/var/www/tp5_nextcloud//themes/example/core/img/favicon-touch.svg
/var/www/tp5_nextcloud//themes/example/core/img/favicon.png
/var/www/tp5_nextcloud//themes/example/core/img/logo.svg
/var/www/tp5_nextcloud//themes/example/core/img/logo-icon.svg
/var/www/tp5_nextcloud//themes/example/core/img/favicon.ico
/var/www/tp5_nextcloud//themes/example/core/css/
/var/www/tp5_nextcloud//themes/example/core/css/server.css
/var/www/tp5_nextcloud//themes/example/defaults.php
/var/www/tp5_nextcloud//themes/README
The current PHP memory limit is below the recommended value of 512MB.
Maintenance mode disabled

[ahliko@web tp5_nextcloud]$ ls -al /srv/backup/
total 30888
drwxr-xr-x. 2 backup backup       39 Jan 31 14:37 .
drwxr-xr-x. 3 root   root         41 Jan 31 14:36 ..
-rw-r--r--. 1 backup backup 31626414 Jan 31 14:37 nextcloud_20230131.tar.gz
```

### 3. Service et timer

🌞 **Créez un *service*** système qui lance le script

```bash
[ahliko@web ~]$ cat /etc/systemd/system/backup.service
[Unit]
Description=Backup The Nextcloud Server
 
[Service]
Type=oneshot
User=backup 
ExecStart=bash /srv/tp6_backup.sh

[Install]
WantedBy=multi-user.target

[ahliko@web ~]$ sudo systemctl daemon-reload
```

```bash
[ahliko@web ~]$ sudo systemctl start backup
[ahliko@web ~]$ systemctl status backup
○ backup.service - Backup The Nextcloud Server
     Loaded: loaded (/etc/systemd/system/backup.service; disabled; vendor preset: disabled)
     Active: inactive (dead)

Jan 31 14:51:22 web.tp6.linux bash[13263]: /var/www/tp5_nextcloud//themes/example/core/css/server.css
Jan 31 14:51:22 web.tp6.linux bash[13263]: /var/www/tp5_nextcloud//themes/example/defaults.php
Jan 31 14:51:22 web.tp6.linux bash[13263]: /var/www/tp5_nextcloud//themes/README
Jan 31 14:51:22 web.tp6.linux bash[13263]: tar: Exiting with failure status due to previous errors
Jan 31 14:51:22 web.tp6.linux bash[13265]: Cannot write into "config" directory!
Jan 31 14:51:22 web.tp6.linux bash[13265]: This can usually be fixed by giving the web server write access to the config directory.
Jan 31 14:51:22 web.tp6.linux bash[13265]: But, if you prefer to keep config.php file read only, set the option "config_is_read_only" to true in it.
Jan 31 14:51:22 web.tp6.linux bash[13265]: See https://docs.nextcloud.com/server/25/go.php?to=admin-config
Jan 31 14:51:22 web.tp6.linux systemd[1]: backup.service: Deactivated successfully.
Jan 31 14:51:22 web.tp6.linux systemd[1]: Finished Backup The Nextcloud Server.
```

🌞 **Créez un *timer*** système qui lance le *service* à intervalles réguliers

```bash
[ahliko@web ~]$ cat /etc/systemd/system/backup.timer
[Unit]
Description=Run service backup

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target

[ahliko@web ~]$ sudo systemctl daemon-reload
```

🌞 Activez l'utilisation du *timer*

```bash
[ahliko@web ~]$ sudo systemctl start backup.timer
[ahliko@web ~]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.
[ahliko@web ~]$ sudo systemctl status backup.timer
● backup.timer - Run service backup
     Loaded: loaded (/etc/systemd/system/backup.timer; enabled; vendor preset: disabled)
     Active: active (waiting) since Tue 2023-01-31 15:00:26 CET; 10s ago
      Until: Tue 2023-01-31 15:00:26 CET; 10s ago
    Trigger: Wed 2023-02-01 04:00:00 CET; 12h left
   Triggers: ● backup.service

Jan 31 15:00:26 web.tp6.linux systemd[1]: Started Run service backup.
[ahliko@web ~]$ sudo systemctl list-timers
NEXT                        LEFT       LAST                        PASSED       UNIT                         ACTIVATES                     
Tue 2023-01-31 15:51:00 CET 50min left Tue 2023-01-31 14:28:14 CET 32min ago    dnf-makecache.timer          dnf-makecache.service
Wed 2023-02-01 00:00:00 CET 8h left    Tue 2023-01-31 09:43:12 CET 5h 17min ago logrotate.timer              logrotate.service
Wed 2023-02-01 04:00:00 CET 12h left   n/a                         n/a          backup.timer                 backup.service
Wed 2023-02-01 12:25:51 CET 21h left   Tue 2023-01-31 12:25:51 CET 2h 34min ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service

4 timers listed.
Pass --all to see loaded but inactive timers, too.
```

## II. NFS

### 1. Serveur NFS

🌞 **Préparer un dossier à partager sur le réseau** (sur la machine `storage.tp6.linux`)

```bash
[ahliko@localhost ~]$ sudo mkdir /srv/nfs_shares/web.tp6.linux/ -p
```

🌞 **Installer le serveur NFS** (sur la machine `storage.tp6.linux`)

```bash
[ahliko@localhost ~]$ sudo dnf install nfs-utils -y
[ahliko@localhost ~]$ sudo chown -R nobody /srv/nfs_shares/
[ahliko@localhost ~]$ ls -al /srv
total 0
drwxr-xr-x.  3 root   root  24 Jan 31 16:01 .
dr-xr-xr-x. 18 root   root 235 Jan  3 10:18 ..
drwxr-xr-x.  3 nobody root  27 Jan 31 16:01 nfs_shares

[ahliko@localhost ~]$ cat /etc/exports
/srv/nfs_shares/web.tp6.linux/    10.105.1.11(rw,sync,no_subtree_check)
[ahliko@localhost ~]$ sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
success
success
success
success

[ahliko@localhost ~]$ sudo systemctl start nfs-server
[ahliko@localhost ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[ahliko@localhost ~]$ systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Tue 2023-01-31 16:10:07 CET; 11s ago
   Main PID: 18040 (code=exited, status=0/SUCCESS)
        CPU: 18ms

Jan 31 16:10:07 localhost.localdomain systemd[1]: Starting NFS server and services...
Jan 31 16:10:07 localhost.localdomain systemd[1]: Finished NFS server and services.
```

### 2. Client NFS

🌞 **Installer un client NFS sur `web.tp6.linux`**
  
```bash
[ahliko@web ~]$ sudo dnf install nfs-utils -y
[ahliko@web ~]$ sudo mount 10.105.1.14:/srv/nfs_shares/web.tp6.linux/ /srv/backup

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
10.105.1.14:/srv/nfs_shares/web.tp6.linux/ /srv/backup nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0

```

🌞 **Tester la restauration des données** sinon ça sert à rien :)

```bash
tar -xvf /srv/backup/backup.tar.gz -C /srv/backup/localbak

rsync -Aax /srv/backup/localbak/config /nextcloud/config
rsync -Aax /srv/backup/localbak/data /nextcloud/data
rsync -Aax /srv/backup/localbak/themes /nextcloud/themes

rm -rf /srv/backup/localbak
```

# Module 3 : Fail2Ban

🌞 Faites en sorte que :

```bash
[ahliko@localhost ~]$ cat install_fail2ban.sh
#!/bin/bash
#---------------------------------
# By Killian Guillemot
# 31/01/2023
# V1.0
#---------------------------------
# Script to Install Fail2Ban on Rocky Linux 9

########################################
# Install epel-release
########################################
dnf install epel-release -y

########################################
# Install Fail2Ban
########################################
dnf install fail2ban -y

cp jail.local /etc/fail2ban/jail.local

systemctl start fail2ban
systemctl enable fail2ban
```

```bash
[ahliko@web ~]$ cat /etc/fail2ban/jail.local | grep find -A 3
# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime  = 10m

# "maxretry" is the number of failures before a host get banned.
maxretry = 5

[ahliko@web ~]$ sudo fail2ban-client status sshd
[sudo] password for ahliko: 
Status for the jail: sshd
|- Filter
|  |- Currently failed:	0
|  |- Total failed:	3
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	1
   |- Total banned:	1
   `- Banned IP list:	10.105.1.13
   
[ahliko@web ~]$ journalctl -xe -u sshd.service -f

Jan 31 16:59:06 web.tp6.linux unix_chkpwd[15290]: password check failed for user (ahliko)
Jan 31 16:59:08 web.tp6.linux sshd[15287]: Failed password for ahliko from 10.105.1.13 port 55380 ssh2
Jan 31 16:59:09 web.tp6.linux kernel: Warning: Deprecated Driver is detected: nft_compat will not be maintained in a future major release and may be disabled
Jan 31 16:59:39 web.tp6.linux sudo[15308]:   ahliko : TTY=pts/0 ; PWD=/etc/fail2ban ; USER=root ; COMMAND=/bin/fail2ban-client status sshd
Jan 31 16:59:39 web.tp6.linux sudo[15308]: pam_unix(sudo:session): session opened for user root(uid=0) by ahliko(uid=1000)
Jan 31 16:59:39 web.tp6.linux sudo[15308]: pam_unix(sudo:session): session closed for user root
Jan 31 17:01:00 web.tp6.linux sshd[15287]: fatal: Timeout before authentication for 10.105.1.13 port 55380
Jan 31 17:01:01 web.tp6.linux CROND[15312]: (root) CMD (run-parts /etc/cron.hourly)
Jan 31 17:01:01 web.tp6.linux run-parts[15315]: (/etc/cron.hourly) starting 0anacron
Jan 31 17:01:01 web.tp6.linux run-parts[15321]: (/etc/cron.hourly) finished 0anacron
Jan 31 17:01:01 web.tp6.linux CROND[15311]: (root) CMDEND (run-parts /etc/cron.hourly)
Jan 31 17:10:51 web.tp6.linux sudo[15364]:   ahliko : TTY=pts/0 ; PWD=/home/ahliko ; USER=root ; COMMAND=/bin/fail2ban-client status sshd
Jan 31 17:10:51 web.tp6.linux sudo[15364]: pam_unix(sudo:session): session opened for user root(uid=0) by ahliko(uid=1000)
Jan 31 17:10:51 web.tp6.linux sudo[15364]: pam_unix(sudo:session): session closed for user root

[ahliko@web ~]$ fail2ban-client set ssh unbanip 10.105.1.13
```