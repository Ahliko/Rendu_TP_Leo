# TP2 : Utilisation courante de Docker

## Sommaire

- [TP2 : Utilisation courante de Docker](#tp2--utilisation-courante-de-docker)
    - [Sommaire](#sommaire)
- [I. Commun à tous : PHP](#i-commun-à-tous--php)
- [II Dév. Python](#ii-dév-python)
- [II Admin. Maîtrise de la stack PHP](#ii-admin-maîtrise-de-la-stack-php)
- [II Secu. Big brain](#ii-secu-big-brain)

# I. Commun à tous : PHP

## Sommaire

- [TP2 Commun : Stack PHP](#tp2-commun--stack-php)
    - [Sommaire](#sommaire)
- [I. Packaging de l'app PHP](#i-packaging-de-lapp-php)


# I. Packaging de l'app PHP


🌞 **`docker-compose.yml`**

127.0.0.1 -> page index.php
127.0.0.1:8080 -> phpmyadmin

[docker-compose.yml](./docker-compose.yml)

# II Dév. Python


## Sommaire

  - [Sommaire](#sommaire)
- [I. Packaging](#i-packaging)
  - [1. Calculatrice](#1-calculatrice)
  - [2. Chat room](#2-chat-room)

# I. Packaging

## 1. Calculatrice

🌞 **Packager l'application de calculatrice réseau**

```bash
 ✘⚙ ahliko@ahliko-PC  [v] 3.11.6  ~/.../TP2/calc_build   main ●  docker build . -t calc:latest
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon   7.68kB
Step 1/12 : FROM rockylinux:9
 ---> b72d2d915008
Step 2/12 : LABEL authors="ahliko"
 ---> Using cache
 ---> bee2b2c173f7
Step 3/12 : RUN dnf update -y
 ---> Using cache
 ---> 931125dac721
Step 4/12 : RUN dnf install -y python3
 ---> Using cache
 ---> 1b6c450ddb5f
Step 5/12 : RUN dnf install -y python3-pip
 ---> Using cache
 ---> 2a39d8e58637
Step 6/12 : RUN pip install --upgrade pip
 ---> Using cache
 ---> 5b955fd7dc88
Step 7/12 : RUN pip install colorlog
 ---> Using cache
 ---> 35723e14cee4
Step 8/12 : RUN pip install psutil
 ---> Using cache
 ---> acfee78a4acb
Step 9/12 : WORKDIR /app
 ---> Using cache
 ---> 8cc4423a35f1
Step 10/12 : COPY chat.py /app
 ---> 241adf6a288c
Step 11/12 : RUN mkdir /var/log/bs_server -m 700 && touch /var/log/bs_server/bs_server.log && chmod 600 /var/log/bs_server/bs_server.log
 ---> Running in 185dba393b7f
Removing intermediate container 185dba393b7f
 ---> 128c2da18453
Step 12/12 : ENTRYPOINT ["python3", "calc.py"]
 ---> Running in adf224bc0853
Removing intermediate container adf224bc0853
 ---> 2570c22bfae0
Successfully built 2570c22bfae0
Successfully tagged calc:latest
```

🌞 **Environnement : adapter le code si besoin**


```bash
 ⚙ ahliko@ahliko-PC  [v] 3.11.6  ~/.../TP2/calc_build   main ●  docker run -e CALC_PORT=6767 -d calc
c36f999c2d7eb0ee74de83df11266fd3db97d5b5c52025f38c54c994227ac1aa
```

🌞 **Logs : adapter le code si besoin**

```bash
 ⚙ ahliko@ahliko-PC  [v] 3.11.6  ~/.../TP2/calc_build   main ●  docker logs c36f999c2d7eb0ee74de83df11266fd3db97d5b5c52025f38c54c994227ac1aa
2023-12-31 18:21:59 INFO Le serveur tourne sur 0.0.0.0:6767
2023-12-31 18:22:59 WARNING Aucun client ne s'est connecté depuis la dernière minute.
```

📜 **Dossier `tp2/calc/` dans le dépôt git de rendu**

[dossier calc](./calc)

## 2. Chat room

🌞 **Packager l'application de chat room**

```bash
 ⚙ ahliko@ahliko-PC  [v] 3.11.6  ~/.../TP2/chat   main ●  docker compose up --build
[+] Building 1.3s (12/12) FINISHED                                                                                                                           docker:default
 => [chat internal] load build definition from Dockerfile                                                                                                              0.0s
 => => transferring dockerfile: 252B                                                                                                                                   0.0s
 => [chat internal] load .dockerignore                                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                                        0.0s
 => [chat internal] load metadata for docker.io/library/python:3.11.7                                                                                                  1.2s
 => [chat 1/7] FROM docker.io/library/python:3.11.7@sha256:4e5e9b05dda9cf699084f20bb1d3463234446387fa0f7a45d90689c48e204c83                                            0.0s
 => [chat internal] load build context                                                                                                                                 0.0s
 => => transferring context: 29B                                                                                                                                       0.0s
 => CACHED [chat 2/7] RUN pip install --upgrade pip                                                                                                                    0.0s
 => CACHED [chat 3/7] RUN pip install colorlog                                                                                                                         0.0s
 => CACHED [chat 4/7] RUN pip install redis                                                                                                                            0.0s
 => CACHED [chat 5/7] RUN pip install websockets                                                                                                                       0.0s
 => CACHED [chat 6/7] WORKDIR /app                                                                                                                                     0.0s
 => CACHED [chat 7/7] COPY chat.py /app                                                                                                                                0.0s
 => [chat] exporting to image                                                                                                                                          0.0s
 => => exporting layers                                                                                                                                                0.0s
 => => writing image sha256:aaab557600871db8f493ede8a7c592f3c99bc84fe8495c85c85ddbc00541a77e                                                                           0.0s
 => => naming to docker.io/library/chat-chat                                                                                                                           0.0s
[+] Running 3/3
 ✔ Network chat_default        Created                                                                                                                                 0.1s 
 ✔ Container MyChatRoomDB      Created                                                                                                                                 0.1s 
 ✔ Container MyChatRoomServer  Created                                                                                                                                 0.1s 
Attaching to MyChatRoomDB, MyChatRoomServer
MyChatRoomDB      | 1:C 31 Dec 2023 19:16:27.290 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
MyChatRoomDB      | 1:C 31 Dec 2023 19:16:27.290 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
MyChatRoomDB      | 1:C 31 Dec 2023 19:16:27.290 * Redis version=7.2.3, bits=64, commit=00000000, modified=0, pid=1, just started
MyChatRoomDB      | 1:C 31 Dec 2023 19:16:27.290 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
MyChatRoomDB      | 1:M 31 Dec 2023 19:16:27.290 * monotonic clock: POSIX clock_gettime
MyChatRoomDB      | 1:M 31 Dec 2023 19:16:27.290 * Running mode=standalone, port=6379.
MyChatRoomDB      | 1:M 31 Dec 2023 19:16:27.291 * Server initialized
MyChatRoomDB      | 1:M 31 Dec 2023 19:16:27.291 * Ready to accept connections tcp
MyChatRoomServer  | 2023-12-31 19:16:27 INFO server listening on 0.0.0.0:8888
MyChatRoomServer  | 2023-12-31 19:17:36 INFO connection open
MyChatRoomServer  | 2023-12-31 19:17:36 INFO New client : ('172.31.0.1', 38904)
MyChatRoomServer  | 2023-12-31 19:17:41 INFO Message received from 172.31.0.1:38904 : 'ciu'
MyChatRoomServer  | 2023-12-31 19:17:42 INFO Message received from 172.31.0.1:38904 : 'dazd'
MyChatRoomServer  | 2023-12-31 19:17:42 INFO Message received from 172.31.0.1:38904 : 'zad'
MyChatRoomServer  | 2023-12-31 19:17:42 INFO Message received from 172.31.0.1:38904 : 'azd'
MyChatRoomServer  | 2023-12-31 19:17:42 INFO Message received from 172.31.0.1:38904 : 'a'
MyChatRoomServer  | 2023-12-31 19:17:42 INFO Message received from 172.31.0.1:38904 : 'd'
MyChatRoomServer  | 2023-12-31 19:17:43 INFO Message received from 172.31.0.1:38904 : 'dz'
MyChatRoomServer  | 2023-12-31 19:18:56 INFO Client ahliko disconnected
MyChatRoomServer  | 2023-12-31 19:18:56 INFO connection closed
```

📜 **Dossier `tp2/chat/` dans le dépôt git de rendu**

[dossier chat](./chat)