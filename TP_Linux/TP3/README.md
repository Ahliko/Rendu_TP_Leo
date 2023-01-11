# TP 3 : We do a little scripting

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

## Rendu

[yt-v2.sh Ici :)](/srv/yt/yt-v2.sh)

```bash
[ ahliko@fedora ~ ] $cat /etc/systemd/system/yt.service
[Unit]
Description=A youtube downloader :)

[Service]
ExecStart=/srv/yt/yt-v2.sh
User=yt

[Install]
WantedBy=multi-user.target
```


```bash
[ ahliko@fedora ~ ] $systemctl status yt
● yt.service - A youtube downloader :)
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disabled)
     Active: active (running) since Wed 2023-01-11 02:01:22 CET; 1min 0s ago
   Main PID: 12633 (yt-v2.sh)
      Tasks: 2 (limit: 33427)
     Memory: 592.0K
        CPU: 16ms
     CGroup: /system.slice/yt.service
             ├─12633 /bin/bash /srv/yt/yt-v2.sh
             └─12758 sleep 10

janv. 11 02:01:22 fedora systemd[1]: Started yt.service - A youtube downloader :).
```
```bash
ahliko@fedora  ~  journalctl -xe -u yt
░░ The unit yt.service has successfully entered the 'dead' state.
janv. 11 01:55:13 fedora systemd[1]: Stopped yt.service - A youtube downloader :).
░░ Subject: L'unité (unit) yt.service a terminé son arrêt
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ L'unité (unit) yt.service a terminé son arrêt.
janv. 11 01:55:14 fedora systemd[1]: Started yt.service - A youtube downloader :).
░░ Subject: L'unité (unit) yt.service a terminé son démarrage
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ L'unité (unit) yt.service a terminé son démarrage, avec le résultat done.
janv. 11 01:55:36 fedora yt-v2.sh[11387]: Already download at : /srv/yt/downloads/The first ten seconds of never gonna give you up
janv. 11 01:56:13 fedora yt-v2.sh[11387]: Video https://www.youtube.com/watch?v=EGohSsaCJOU was downloaded.
janv. 11 01:56:13 fedora yt-v2.sh[11387]: File path : /srv/yt/downloads/The first ten seconds of never gonna give you up/The first ten seconds of never gonna give you up.mp4
janv. 11 01:56:47 fedora systemd[1]: Stopping yt.service - A youtube downloader :)...
░░ Subject: L'unité (unit) yt.service a commencé à s'arrêter
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ L'unité (unit) yt.service a commencé à s'arrêter.
janv. 11 01:56:47 fedora systemd[1]: yt.service: Deactivated successfully.
░░ Subject: Unit succeeded
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ The unit yt.service has successfully entered the 'dead' state.
janv. 11 01:56:47 fedora systemd[1]: Stopped yt.service - A youtube downloader :).
░░ Subject: L'unité (unit) yt.service a terminé son arrêt
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ L'unité (unit) yt.service a terminé son arrêt.
janv. 11 01:56:47 fedora systemd[1]: yt.service: Consumed 3.492s CPU time.
░░ Subject: Ressources consommées durant l'éxécution de l'unité (unit)
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ L'unité (unit) yt.service s'est arrêtée et a consommé les ressources indiquées.
```


![https://asciinema.org/a/gvsXzq91E9X5K8ipP8C5cVimg](https://asciinema.org/a/gvsXzq91E9X5K8ipP8C5cVimg.png)

# IV. Bonus

➜ **en accord avec les règles de [ShellCheck](https://www.shellcheck.net/)**
- vérifiez à l'aide d'une expression régulière que les strings saisies dans le fichier sont bien des URLs de vidéos Youtube