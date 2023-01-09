# TP 3 : We do a little scripting

![https://asciinema.org/a/gvsXzq91E9X5K8ipP8C5cVimg](https://asciinema.org/a/gvsXzq91E9X5K8ipP8C5cVimg.png)

## Sommaire

- [TP 3 : We do a little scripting](#tp-3--we-do-a-little-scripting)
    - [Sommaire](#sommaire)
- [0. Un premier script](#0-un-premier-script)
- [I. Script carte d'identité](#i-script-carte-didentité)
    - [Rendu](#rendu)
- [II. Script youtube-dl](#ii-script-youtube-dl)
    - [Rendu](#rendu-1)
- [III. MAKE IT A SERVICE](#iii-make-it-a-service)
    - [Rendu](#rendu-2)
- [IV. Bonus](#iv-bonus)

# 0. Un premier script

🌞 **Vous fournirez dans le compte-rendu**, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.

[idcard.sh Ici :)](/srv/idcard/idcard.sh)

```bash
[ ahliko@fedora  ~ ] $ bash /srv/idcard/idcard.sh
Machine Name : fedora
OS Fedora release 37 (Thirty Seven) and kernel version is Linux fedora 6.0.17-300.fc37.x86_64
IP : 10.33.18.194/22
RAM : 15Gi memory available on 27Gi total memory
Disk : 147G space left
Top 5 processes by RAM usage :
  - /home/ahliko/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/223.8214.52/jbr/bin/java
  - /home/ahliko/.local/share/JetBrains/Toolbox/apps/Fleet/ch-0/1.13.92/bin/Fleet
  - /usr/lib64/opera/opera
  - /usr/lib64/discord/Discord
  - /usr/libexec/packagekitd
Listening ports :
  - 48425 udp : avahi-daemon
  - 53 udp : systemd-resolve
  - 53 udp : systemd-resolve
  - 323 udp : chronyd
  - 5353 udp : opera
  - 5353 udp : avahi-daemon
  - 5355 udp : systemd-resolve
  - 53 tcp : systemd-resolve
  - 6463 tcp : Discord
  - 5355 tcp : systemd-resolve
  - 631 tcp : cupsd
  - 53 tcp : systemd-resolve

Here is your random cat : ./cat.jpeg
```

# II. Script youtube-dl

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, **un exemple d'exécution avec une sortie**, dans des balises de code.

[yt.sh Ici :)](/srv/yt/yt.sh)

[download.log Ici :)](/var/log/download.log)

```bash
[ ahliko@fedora /srv/yt ] $ ./yt.sh https://www.youtube.com/watch\?v\=EGohSsaCJOU
Video https://www.youtube.com/watch?v=EGohSsaCJOU was downloaded.
File path : /srv/yt/downloads/The first ten seconds of never gonna give you up/The first ten seconds of never gonna give you up.mp4
```

```bash
[ ahliko@fedora ~ ] $ cat /var/log/yt/download.log 
[2023/01/09 18:05:43] Video https://www.youtube.com/watch?v=EGohSsaCJOU was downloaded. File path : /srv/yt/downloads/The first ten seconds of never gonna give you up/The first ten seconds of never gonna give you up.mp4
```

# III. MAKE IT A SERVICE

YES. Yet again. **On va en faire un [service](../../cours/notions/serveur/README.md#ii-service).**

L'idée :

➜ plutôt que d'appeler la commande à la main quand on veut télécharger une vidéo, **on va créer un service qui les téléchargera pour nous**

➜ le service devra **lire en permanence dans un fichier**

- s'il trouve une nouvelle ligne dans le fichier, il vérifie que c'est bien une URL de vidéo youtube
    - si oui, il la télécharge, puis enlève la ligne
    - sinon, il enlève juste la ligne

➜ **qui écrit dans le fichier pour ajouter des URLs ? Bah vous !**

- vous pouvez écrire une liste d'URL, une par ligne, et le service devra les télécharger une par une

---

Pour ça, procédez par étape :

- **partez de votre script précédent** (gardez une copie propre du premier script, qui doit être livré dans le dépôt git)
    - le nouveau script s'appellera `yt-v2.sh`
- **adaptez-le pour qu'il lise les URL dans un fichier** plutôt qu'en argument sur la ligne de commande
- **faites en sorte qu'il tourne en permanence**, et vérifie le contenu du fichier toutes les X secondes
    - boucle infinie qui :
        - lit un fichier
        - effectue des actions si le fichier n'est pas vide
        - sleep pendant une durée déterminée
- **il doit marcher si on précise une vidéo par ligne**
    - il les télécharge une par une
    - et supprime les lignes une par une

➜ **une fois que tout ça fonctionne, enfin, créez un service** qui lance votre script :

- créez un fichier `/etc/systemd/system/yt.service`. Il comporte :
    - une brève description
    - un `ExecStart` pour indiquer que ce service sert à lancer votre script
    - une clause `User=` pour indiquer que c'est l'utilisateur `yt` qui lance le script
        - créez l'utilisateur s'il n'existe pas
        - faites en sorte que le dossier `/srv/yt` et tout son contenu lui appartienne
        - le dossier de log doit lui appartenir aussi
        - l'utilisateur `yt` ne doit pas pouvoir se connecter sur la machine

```bash
[Unit]
Description=<Votre description>

[Service]
ExecStart=<Votre script>
User=yt

[Install]
WantedBy=multi-user.target
```

> Pour rappel, après la moindre modification dans le dossier `/etc/systemd/system/`, vous devez exécuter la commande `sudo systemctl daemon-reload` pour dire au système de lire les changements qu'on a effectué.

Vous pourrez alors interagir avec votre service à l'aide des commandes habituelles `systemctl` :

- `systemctl status yt`
- `sudo systemctl start yt`
- `sudo systemctl stop yt`

![Now witness](./pics/now_witness.png)

## Rendu

📁 **Le script `/srv/yt/yt-v2.sh`**

📁 **Fichier `/etc/systemd/system/yt.service`**

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- un `systemctl status yt` quand le service est en cours de fonctionnement
- un extrait de `journalctl -xe -u yt`

> Hé oui les commandes `journalctl` fonctionnent sur votre service pour voir les logs ! Et vous devriez constater que c'est vos `echo` qui pop. En résumé, **le STDOUT de votre script, c'est devenu les logs du service !**

🌟**BONUS** : get fancy. Livrez moi un gif ou un [asciinema](https://asciinema.org/) (PS : c'est le feu asciinema) de votre service en action, où on voit les URLs de vidéos disparaître, et les fichiers apparaître dans le fichier de destination

# IV. Bonus

Quelques bonus pour améliorer le fonctionnement de votre script :

➜ **en accord avec les règles de [ShellCheck](https://www.shellcheck.net/)**

- bonnes pratiques, sécurité, lisibilité

➜  **fonction `usage`**

- le script comporte une fonction `usage`
- c'est la fonction qui est appelée lorsque l'on appelle le script avec une erreur de syntaxe
- ou lorsqu'on appelle le `-h` du script

➜ **votre script a une gestion d'options :**

- `-q` pour préciser la qualité des vidéos téléchargées (on peut choisir avec `youtube-dl`)
- `-o` pour préciser un dossier autre que `/srv/yt/`
- `-h` affiche l'usage

➜ **si votre script utilise des commandes non-présentes à l'installation** (`youtube-dl`, `jq` éventuellement, etc.)

- vous devez TESTER leur présence et refuser l'exécution du script

➜  **si votre script a besoin de l'existence d'un dossier ou d'un utilisateur**

- vous devez tester leur présence, sinon refuser l'exécution du script

➜ **pour le téléchargement des vidéos**

- vérifiez à l'aide d'une expression régulière que les strings saisies dans le fichier sont bien des URLs de vidéos Youtube