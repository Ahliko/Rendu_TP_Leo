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
Step 10/12 : COPY calc.py /app
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

![Cat Whale](./img/cat_whale.png)

🌞 **Packager l'application de chat room**

- pareil : on package le serveur
- `Dockerfile` et `docker-compose.yml`
- code adapté :
  - logs en sortie standard
  - variable d'environnement `CHAT_PORT` pour le port d'écoute
  - variable d'environnement `MAX_USERS` pour limiter le nombre de users dans chaque room (ou la room s'il y en a qu'une)
- encore un README propre qui montre comment build et comment run (en démontrant l'utilisation des variables d'environnement)

📜 **Dossier `tp2/chat/` dans le dépôt git de rendu**

- `Dockerfile`
- `docker-compose.yml`
- `README.md`
- `chat.py` : le code de l'app chat room

➜ **J'espère que ces cours vous ont apporté du recul sur la relation client/serveur**

- deux programmes distincts, chacun a son rôle
  - le serveur
    - est le gardien de la logique, le maître du jeu, garant du respect des règles
    - c'est votre bébé vous le maîtrisez
    - opti et sécu en tête
  - le client c'est... le client
    - faut juste qu'il soit joooooli
    - garder à l'esprit que n'importe qui peut le modifier ou l'adapter
    - ou carrément dév son propre client
- y'a même des milieux comme le web, où les gars qui dév les serveurs (Apache, NGINX, etc) c'est pas DU TOUT les mêmes qui dévs les clients (navigateurs Web, `curl`, librairie `requests` en Python, etc)