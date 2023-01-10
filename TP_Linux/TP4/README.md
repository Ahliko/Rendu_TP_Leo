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