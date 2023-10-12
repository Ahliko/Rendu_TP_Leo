#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Install MariaDB on Rocky Linux 9
# By Killian Guillemot
# V1.0
# ------------------------------------------------------------------------------

# DNF Install
echo "------------------------------------------------------------------------"
echo "Install mariadb"
echo "------------------------------------------------------------------------"
dnf install mariadb-server -y 2> install.log
echo "------------------------------------------------------------------------"
echo "Start mariadb"
echo "------------------------------------------------------------------------"
if $(systemctl is-active --quiet mariadb); then
    systemctl restart mariadb 2> install.log
else
    systemctl start mariadb 2> install.log
fi

if $(systemctl is-enabled --quiet mariadb); then
    echo "mariadb is enabled"
else
    systemctl enable mariadb 2> install.log
fi


# Configure SELinux and hostname
echo "------------------------------------------------------------------------"
echo "Hostaname"
echo "------------------------------------------------------------------------"
echo "db.tp5.linux" > /etc/hostname 2> install.log
echo "------------------------------------------------------------------------"
echo "Copy selinux.conf"
echo "------------------------------------------------------------------------"
cp conf.d/selinux.conf /etc/selinux/config 2> install.log

# Configure MariaDB
echo "------------------------------------------------------------------------"
echo "Configurate MariaDB"
echo "------------------------------------------------------------------------"
mysql_secure_installation 2> install.log

echo "------------------------------------------------------------------------"
echo "Restart mariadb"
echo "------------------------------------------------------------------------"
systemctl restart mariadb 2> install.log

# Create Database
echo "------------------------------------------------------------------------"
echo "Create Database"
echo "------------------------------------------------------------------------"
mysql -u root -p -e "CREATE DATABASE nextcloud; CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud'; GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost'; FLUSH PRIVILEGES;" 2> install.log

# Configure Firewall
echo "------------------------------------------------------------------------"
echo "Firewall configuration port 3306"
echo "------------------------------------------------------------------------"
firewall-cmd --add-port=3306/tcp --permanent 2> install.log
firewall-cmd --reload 2> install.log

