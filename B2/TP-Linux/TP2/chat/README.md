# The docker-chatroom

## Sommaire

- [The docker-chatroom](#the-docker-chatroom)
  - [Sommaire](#sommaire)
  - [Installation](#installation)

## Installation

Pour installer le projet, il suffit de cloner le dépôt git et de lancer le docker-compose.

```bash
$ git clone https://github.com/Ahliko/Rendu_TP_Leo.git
$ cd B2/TP-Linux/TP2/chat
$ docker-compose up -d --build
```

Si vous voulez changer le port, vous pouvez changer le port dans le fichier docker-compose.yml.
De même pour le nombre de clients maximums, vous pouvez changer le nombre de clients dans le fichier docker-compose.yml.