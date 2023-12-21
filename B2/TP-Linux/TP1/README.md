# TP1 : Premiers pas Docker


## Sommaire

- [TP1 : Premiers pas Docker](#tp1--premiers-pas-docker)
    - [Sommaire](#sommaire)
- [I. Init](#i-init)
- [II. Images](#ii-images)
- [III. Docker compose](#iii-docker-compose)


# I. Init

- [I. Init](#i-init)
    - [3. sudo c pa bo](#3-sudo-c-pa-bo)
    - [4. Un premier conteneur en vif](#4-un-premier-conteneur-en-vif)
    - [5. Un deuxième conteneur en vif](#5-un-deuxième-conteneur-en-vif)




## 3. sudo c pa bo


🌞 **Ajouter votre utilisateur au groupe `docker`**

```bash
[ahliko@TP1 ~]$ sudo usermod -aG docker $(whoami)
[ahliko@TP1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```

## 4. Un premier conteneur en vif


🌞 **Lancer un conteneur NGINX**

```bash
[ahliko@TP1 ~]$ docker run -d -p 9999:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
af107e978371: Pull complete 
336ba1f05c3e: Pull complete 
8c37d2ff6efa: Pull complete 
51d6357098de: Pull complete 
782f1ecce57d: Pull complete 
5e99d351b073: Pull complete 
7b73345df136: Pull complete 
Digest: sha256:bd30b8d47b230de52431cc71c5cce149b8d5d4c87c204902acf2504435d4b4c9
Status: Downloaded newer image for nginx:latest
02638d2e35af2a8db50a571318d08a2906c7875fdd4d628fe880714bf00162cb
```

🌞 **Visitons**

```bash
[ahliko@TP1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
02638d2e35af   nginx     "/docker-entrypoint.…"   23 seconds ago   Up 22 seconds   0.0.0.0:9999->80/tcp, :::9999->80/tcp   romantic_mclaren
[ahliko@TP1 ~]$ docker logs 02638d2e35af
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2023/12/21 10:06:38 [notice] 1#1: using the "epoll" event method
2023/12/21 10:06:38 [notice] 1#1: nginx/1.25.3
2023/12/21 10:06:38 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14) 
2023/12/21 10:06:38 [notice] 1#1: OS: Linux 5.14.0-284.30.1.el9_2.x86_64
2023/12/21 10:06:38 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1073741816:1073741816
2023/12/21 10:06:38 [notice] 1#1: start worker processes
2023/12/21 10:06:38 [notice] 1#1: start worker process 29
2023/12/21 10:06:38 [notice] 1#1: start worker process 30
[ahliko@TP1 ~]$ docker inspect 02638d2e35af
[
    {
        "Id": "02638d2e35af2a8db50a571318d08a2906c7875fdd4d628fe880714bf00162cb",
        "Created": "2023-12-21T10:06:38.107214545Z",
...}
]
[ahliko@TP1 ~]$ sudo ss -lnpt
State   Recv-Q  Send-Q   Local Address:Port   Peer Address:Port Process                                  
LISTEN  0       4096           0.0.0.0:9999        0.0.0.0:*     users:(("docker-proxy",pid=56811,fd=4)) 
LISTEN  0       128            0.0.0.0:22          0.0.0.0:*     users:(("sshd",pid=30822,fd=3))         
LISTEN  0       4096              [::]:9999           [::]:*     users:(("docker-proxy",pid=56817,fd=4)) 
LISTEN  0       128               [::]:22             [::]:*     users:(("sshd",pid=30822,fd=4))
[ahliko@TP1 ~]$ sudo firewall-cmd --add-port=9999/tcp
success
[ahliko@TP1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 9999/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

 ahliko@ahliko-PC  ~  curl 10.1.1.10:9999
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

🌞 **On va ajouter un site Web au conteneur NGINX**

```bash
[ahliko@TP1 ~]$ pwd
/home/ahliko
[ahliko@TP1 ~]$ mkdir nginx
[ahliko@TP1 nginx]$ cat index.html 
<h1>MEOOOW</h1>
[ahliko@TP1 nginx]$ cat site_nul.conf 
server {
    listen        8080;

    location / {
        root /var/www/html;
    }
}

[ahliko@TP1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
02638d2e35af   nginx     "/docker-entrypoint.…"   14 minutes ago   Up 14 minutes   0.0.0.0:9999->80/tcp, :::9999->80/tcp   romantic_mclaren
[ahliko@TP1 ~]$ docker rm -f 02638d2e35af
02638d2e35af
[ahliko@TP1 ~]$ docker run -d -p 9999:8080 -v /home/$USER/nginx/index.html:/var/www/html/index.html -v /home/$USER/nginx/site_nul.conf:/etc/nginx/conf.d/site_nul.conf nginx
a5934a9af43d672c09b3aa8ec887032cfe09e9067d1a11af8ec5ce018d3ad586
```

🌞 **Visitons**

```bash
[ahliko@TP1 ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                               NAMES
a5934a9af43d   nginx     "/docker-entrypoint.…"   14 seconds ago   Up 13 seconds   80/tcp, 0.0.0.0:9999->8080/tcp, :::9999->8080/tcp   relaxed_moore
 ahliko@ahliko-PC  ~  curl 10.1.1.10:9999
<h1>MEOOOW</h1>
```

## 5. Un deuxième conteneur en vif

🌞 **Lance un conteneur Python, avec un shell**


```bash
[ahliko@TP1 ~]$ docker run -it python bash
Unable to find image 'python:latest' locally
latest: Pulling from library/python
bc0734b949dc: Pull complete 
b5de22c0f5cd: Pull complete 
917ee5330e73: Pull complete 
b43bd898d5fb: Pull complete 
7fad4bffde24: Pull complete 
d685eb68699f: Pull complete 
107007f161d0: Pull complete 
02b85463d724: Pull complete 
Digest: sha256:3733015cdd1bd7d9a0b9fe21a925b608de82131aa4f3d397e465a1fcb545d36f
Status: Downloaded newer image for python:latest
root@67248a279bd2:/# 
```

🌞 **Installe des libs Python**

```bash
root@67248a279bd2:/# pip install aiohttp
Collecting aiohttp
  Obtaining dependency information for aiohttp from https://files.pythonhosted.org/packages/75/5f/90a2869ad3d1fb9bd984bfc1b02d8b19e381467b238bd3668a09faa69df5/aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (7.4 kB)
Collecting attrs>=17.3.0 (from aiohttp)
  Downloading attrs-23.1.0-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.2/61.2 kB 2.1 MB/s eta 0:00:00
Collecting multidict<7.0,>=4.5 (from aiohttp)
  Downloading multidict-6.0.4.tar.gz (51 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 51.3/51.3 kB 3.1 MB/s eta 0:00:00
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Installing backend dependencies ... done
  Preparing metadata (pyproject.toml) ... done
Collecting yarl<2.0,>=1.0 (from aiohttp)
  Obtaining dependency information for yarl<2.0,>=1.0 from https://files.pythonhosted.org/packages/28/1c/bdb3411467b805737dd2720b85fd082e49f59bf0cc12dc1dfcc80ab3d274/yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (31 kB)
Collecting frozenlist>=1.1.1 (from aiohttp)
  Obtaining dependency information for frozenlist>=1.1.1 from https://files.pythonhosted.org/packages/0b/f2/b8158a0f06faefec33f4dff6345a575c18095a44e52d4f10c678c137d0e0/frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (12 kB)
Collecting aiosignal>=1.1.2 (from aiohttp)
  Downloading aiosignal-1.3.1-py3-none-any.whl (7.6 kB)
Collecting idna>=2.0 (from yarl<2.0,>=1.0->aiohttp)
  Obtaining dependency information for idna>=2.0 from https://files.pythonhosted.org/packages/c2/e7/a82b05cf63a603df6e68d59ae6a68bf5064484a0718ea5033660af4b54a9/idna-3.6-py3-none-any.whl.metadata
  Downloading idna-3.6-py3-none-any.whl.metadata (9.9 kB)
Downloading aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.3 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.3/1.3 MB 22.1 MB/s eta 0:00:00
Downloading frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (281 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 281.5/281.5 kB 16.1 MB/s eta 0:00:00
Downloading yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (322 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 322.4/322.4 kB 5.8 MB/s eta 0:00:00
Downloading idna-3.6-py3-none-any.whl (61 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.6/61.6 kB 4.5 MB/s eta 0:00:00
Building wheels for collected packages: multidict
  Building wheel for multidict (pyproject.toml) ... done
  Created wheel for multidict: filename=multidict-6.0.4-cp312-cp312-linux_x86_64.whl size=114920 sha256=f031131193e5fb38f153ee3dd9be9dc98ab35e85889bb4818c3f6385478d4188
  Stored in directory: /root/.cache/pip/wheels/f6/d8/ff/3c14a64b8f2ab1aa94ba2888f5a988be6ab446ec5c8d1a82da
Successfully built multidict
Installing collected packages: multidict, idna, frozenlist, attrs, yarl, aiosignal, aiohttp
Successfully installed aiohttp-3.9.1 aiosignal-1.3.1 attrs-23.1.0 frozenlist-1.4.1 idna-3.6 multidict-6.0.4 yarl-1.9.4
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip is available: 23.2.1 -> 23.3.2
[notice] To update, run: pip install --upgrade pip

root@67248a279bd2:/# pip install aioconsole
Collecting aioconsole
  Downloading aioconsole-0.7.0-py3-none-any.whl.metadata (5.3 kB)
Downloading aioconsole-0.7.0-py3-none-any.whl (30 kB)
Installing collected packages: aioconsole
Successfully installed aioconsole-0.7.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
root@67248a279bd2:/# python
Python 3.12.1 (main, Dec 19 2023, 20:14:15) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import aiohttp

```

# II. Images

# II. Images

- [II. Images](#ii-images)
  - [1. Images publiques](#1-images-publiques)
  - [2. Construire une image](#2-construire-une-image)

## 1. Images publiques

🌞 **Récupérez des images**


```bash
[ahliko@TP1 ~]$ docker pull python:3.11
3.11: Pulling from library/python
bc0734b949dc: Already exists 
b5de22c0f5cd: Already exists 
917ee5330e73: Already exists 
b43bd898d5fb: Already exists 
7fad4bffde24: Already exists 
1f68ce6a3e62: Pull complete 
e27d998f416b: Pull complete 
fefdcd9854bf: Pull complete 
Digest: sha256:4e5e9b05dda9cf699084f20bb1d3463234446387fa0f7a45d90689c48e204c83
Status: Downloaded newer image for python:3.11
docker.io/library/python:3.11
[ahliko@TP1 ~]$ docker pull mysql:5.7
5.7: Pulling from library/mysql
20e4dcae4c69: Pull complete 
1c56c3d4ce74: Pull complete 
e9f03a1c24ce: Pull complete 
68c3898c2015: Pull complete 
6b95a940e7b6: Pull complete 
90986bb8de6e: Pull complete 
ae71319cb779: Pull complete 
ffc89e9dfd88: Pull complete 
43d05e938198: Pull complete 
064b2d298fba: Pull complete 
df9a4d85569b: Pull complete 
Digest: sha256:4bc6bc963e6d8443453676cae56536f4b8156d78bae03c0145cbe47c2aad73bb
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7
[ahliko@TP1 ~]$ docker pull wordpress:latest
latest: Pulling from library/wordpress
af107e978371: Already exists 
6480d4ad61d2: Pull complete 
95f5176ece8b: Pull complete 
0ebe7ec824ca: Pull complete 
673e01769ec9: Pull complete 
74f0c50b3097: Pull complete 
1a19a72eb529: Pull complete 
50436df89cfb: Pull complete 
8b616b90f7e6: Pull complete 
df9d2e4043f8: Pull complete 
d6236f3e94a1: Pull complete 
59fa8b76a6b3: Pull complete 
99eb3419cf60: Pull complete 
22f5c20b545d: Pull complete 
1f0d2c1603d0: Pull complete 
4624824acfea: Pull complete 
79c3af11cab5: Pull complete 
e8d8239610fb: Pull complete 
a1ff013e1d94: Pull complete 
31076364071c: Pull complete 
87728bbad961: Pull complete 
Digest: sha256:be7173998a8fa131b132cbf69d3ea0239ff62be006f1ec11895758cf7b1acd9e
Status: Downloaded newer image for wordpress:latest
docker.io/library/wordpress:latest
[ahliko@TP1 ~]$ docker pull linuxserver/wikijs:latest
latest: Pulling from linuxserver/wikijs
8b16ab80b9bd: Pull complete 
07a0e16f7be1: Pull complete 
145cda5894de: Pull complete 
1a16fa4f6192: Pull complete 
84d558be1106: Pull complete 
4573be43bb06: Pull complete 
20b23561c7ea: Pull complete 
Digest: sha256:131d247ab257cc3de56232b75917d6f4e24e07c461c9481b0e7072ae8eba3071
Status: Downloaded newer image for linuxserver/wikijs:latest
docker.io/linuxserver/wikijs:latest

[ahliko@TP1 ~]$ docker images
REPOSITORY           TAG       IMAGE ID       CREATED       SIZE
linuxserver/wikijs   latest    869729f6d3c5   5 days ago    441MB
mysql                5.7       5107333e08a8   8 days ago    501MB
python               latest    fc7a60e86bae   13 days ago   1.02GB
wordpress            latest    fd2f5a0c6fba   2 weeks ago   739MB
python               3.11      22140cbb3b0c   2 weeks ago   1.01GB
nginx                latest    d453dd892d93   8 weeks ago   187MB
```

🌞 **Lancez un conteneur à partir de l'image Python**

```bash
[ahliko@TP1 ~]$ docker run -it python:3.11 bash
root@d2510d221329:/# python --version
Python 3.11.7
```

## 2. Construire une image

🌞 **Ecrire un Dockerfile pour une image qui héberge une application Python**

[Le Dockerfile](./Dockerfile)
```bash
[ahliko@TP1 ~]$ mkdir python_app_build
[ahliko@TP1 ~]$ cat python_app_build/app.py 
import emoji

print(emoji.emojize("Cet exemple d'application est vraiment naze :thumbs_down:"))
[ahliko@TP1 ~]$ ll python_app_build/
total 8
-rw-r--r--. 1 ahliko ahliko 159 Dec 21 11:45 Dockerfile
-rw-r--r--. 1 ahliko ahliko  96 Dec 21 11:43 app.py
```

🌞 **Build l'image**

```bash
[ahliko@TP1 ~]$ cd python_app_build
[ahliko@TP1 python_app_build]$ docker build . -t python_app:version_de_ouf
[+] Building 5.1s (12/12) FINISHED                                                        docker:default
 => [internal] load build definition from Dockerfile                                                0.0s
 => => transferring dockerfile: 305B                                                                0.0s
 => [internal] load .dockerignore                                                                   0.0s
 => => transferring context: 2B                                                                     0.0s
 => [internal] load metadata for docker.io/library/debian:latest                                    1.3s
 => [1/7] FROM docker.io/library/debian@sha256:bac353db4cc04bc672b14029964e686cd7bad56fe34b51f432c  0.0s
 => [internal] load build context                                                                   0.0s
 => => transferring context: 86B                                                                    0.0s
 => CACHED [2/7] RUN apt update -y                                                                  0.0s
 => CACHED [3/7] RUN apt install python3 -y                                                         0.0s
 => CACHED [4/7] RUN apt install python3-pip -y                                                     0.0s
 => [5/7] RUN pip install emoji --break-system-packages                                             1.2s
 => [6/7] WORKDIR /app                                                                              0.1s 
 => [7/7] COPY app.py /app/app.py                                                                   0.1s 
 => exporting to image                                                                              2.2s 
 => => exporting layers                                                                             2.2s 
 => => writing image sha256:68a9b9b5f1bbc8bd0f735e54e08ede516f6838d5fe2b9a34e754e4783efa6aea        0.0s 
 => => naming to docker.io/library/python_app:version_de_ouf                                        0.0s
[ahliko@TP1 python_app_build]$ docker images
REPOSITORY           TAG              IMAGE ID       CREATED         SIZE
python_app           version_de_ouf   68a9b9b5f1bb   2 minutes ago   638MB
```

🌞 **Lancer l'image**

```bash
[ahliko@TP1 python_app_build]$ docker run python_app:version_de_ouf
Cet exemple d'application est vraiment naze 👎
```

# III. Docker compose

🌞 **Créez un fichier `docker-compose.yml`**

```bash
[ahliko@TP1 ~]$ mkdir compose_test
[ahliko@TP1 compose_test]$ ll
total 4
-rw-r--r--. 1 ahliko ahliko 154 Dec 21 12:14 docker-compose.yml
[ahliko@TP1 compose_test]$ cat docker-compose.yml 
version: "3"

services:
  conteneur_nul:
    image: debian
    entrypoint: sleep 9999
  conteneur_flopesque:
    image: debian
    entrypoint: sleep 9999
```

🌞 **Lancez les deux conteneurs** avec `docker compose`

```bash
[ahliko@TP1 compose_test]$ pwd
/home/ahliko/compose_test
[ahliko@TP1 compose_test]$ docker compose up -d
[+] Running 3/3
 ✔ conteneur_flopesque 1 layers [⣿]      0B/0B      Pulled                                         19.1s 
   ✔ bc0734b949dc Already exists                                                                    0.0s 
 ✔ conteneur_nul Pulled                                                                            19.1s 
[+] Running 3/3
 ✔ Network compose_test_default                  Created                                            0.2s 
 ✔ Container compose_test-conteneur_nul-1        Starte...                                          0.1s 
 ✔ Container compose_test-conteneur_flopesque-1  Started                                            0.1s

```
🌞 **Vérifier que les deux conteneurs tournent**

```bash
[ahliko@TP1 compose_test]$ docker compose ps
NAME                                 IMAGE     COMMAND        SERVICE               CREATED          STATUS          PORTS
compose_test-conteneur_flopesque-1   debian    "sleep 9999"   conteneur_flopesque   39 seconds ago   Up 37 seconds   
compose_test-conteneur_nul-1         debian    "sleep 9999"   conteneur_nul         39 seconds ago   Up 38 seconds
```

🌞 **Pop un shell dans le conteneur `conteneur_nul`**

```bash
[ahliko@TP1 compose_test]$ docker exec -it compose_test-conteneur_nul-1 bash
root@619fa3c07d81:/#
root@619fa3c07d81:/# apt update -y && apt install iputils-ping -y
root@619fa3c07d81:/# ping conteneur_flopesque
PING conteneur_flopesque (172.18.0.3) 56(84) bytes of data.
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=1 ttl=64 time=0.088 ms
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=2 ttl=64 time=0.106 ms
^C
--- conteneur_flopesque ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1062ms
rtt min/avg/max/mdev = 0.088/0.097/0.106/0.009 ms
```