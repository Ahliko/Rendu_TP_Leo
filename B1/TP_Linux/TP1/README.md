# TP1 : Are you dead yet ?


- [TP1 : Are you dead yet ?](#tp1--are-you-dead-yet-)
- [II. Feu](#ii-feu)


## II. Feu

🌞 **Trouver au moins 4 façons différentes de péter la machine**

Remplacer bit par bit /dev/sda avec des bits random
- [x] 1. `sudo dd if=/dev/random of=/dev/sda bs=4M`

Supprimer la table de partition de sda
- [x] 2. `sudo fdisk /dev/sda`
    `g`
    `w`

Supprimer le fichier de conf de grub
- [x] 3. `sudo vim /boot/grub2/grub.cfg`
    `dd`
    `ur grub is now broken`

Supprimer bash
- [x] 4. `sudo rm /bin/bash`