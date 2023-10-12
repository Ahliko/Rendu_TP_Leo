#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Install Nextcloud on Rocky Linux 9
# By Killian Guillemot
# V1.0
# ------------------------------------------------------------------------------

# DNF Install
echo "------------------------------------------------------------------------"
echo "Install httpd"
echo "------------------------------------------------------------------------"
dnf install httpd -y 2> install.log
echo "------------------------------------------------------------------------"
echo "Install wget"
echo "------------------------------------------------------------------------"
dnf install wget -y 2> install.log
echo "------------------------------------------------------------------------"
echo "Install unzip"
echo "------------------------------------------------------------------------"
dnf install unzip -y 2> install.log
echo "------------------------------------------------------------------------"
echo "config-manager"
echo "------------------------------------------------------------------------"
dnf config-manager --set-enabled crb 2> install.log
echo "------------------------------------------------------------------------"
echo "Install dnf-utils"
echo "------------------------------------------------------------------------"
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y 2> install.log
7echo "------------------------------------------------------------------------"
 echo "Install module list php"
 echo "------------------------------------------------------------------------"
dnf module list php 2> install.log
echo "------------------------------------------------------------------------"
echo "module enable php"
echo "------------------------------------------------------------------------"
dnf module enable php:remi-8.1 -y 2> install.log
echo "------------------------------------------------------------------------"
echo "Install php81-php"
echo "------------------------------------------------------------------------"
dnf install -y php81-php 2> install.log
echo "------------------------------------------------------------------------"
echo "Install final_php"
echo "------------------------------------------------------------------------"
dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp 2> install.log

# Configure SELinux and hostname
echo "------------------------------------------------------------------------"
echo "Hostaname"
echo "------------------------------------------------------------------------"
echo "web.tp5.linux" > /etc/hostname 2> install.log
echo "------------------------------------------------------------------------"
echo "Copy selinux.conf"
echo "------------------------------------------------------------------------"
cp conf.d/selinux.conf /etc/selinux/config 2> install.log

# Configure Apache
echo "------------------------------------------------------------------------"
echo "Copy httpd.conf"
echo "------------------------------------------------------------------------"
cp conf.d/httpd.conf /etc/httpd/conf/httpd.conf 2> install.log
echo "------------------------------------------------------------------------"
echo "Copy nextcloud.conf"
echo "------------------------------------------------------------------------"
cp conf.d/nextcloud.conf /etc/httpd/conf.d/nextcloud.conf 2> install.log

# Download Nextcloud
echo "------------------------------------------------------------------------"
echo "Download Nextcloud"
echo "------------------------------------------------------------------------"
wget https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip 2> install.log
unzip nextcloud-25.0.0rc3.zip -d /var/www 2> install.log
chown -R apache /var/www/nextcloud 2> install.log

# Configure Firewall
echo "------------------------------------------------------------------------"
echo "Firewall port 80"
echo "------------------------------------------------------------------------"
firewall-cmd --add-port=80/tcp --permanent 2> install.log
firewall-cmd --reload 2> install.log

# Start Apache
echo "------------------------------------------------------------------------"
echo "Start Apache"
echo "------------------------------------------------------------------------"
systemctl start httpd 2> install.log
systemctl enable httpd 2> install.log