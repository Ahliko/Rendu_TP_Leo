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

