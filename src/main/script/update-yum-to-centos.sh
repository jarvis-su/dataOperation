#!/bin/bash

BASE_ARCH=x86_64
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi
 
 
clear
echo "========================================================================="
echo "Replace Redhat Enterprise Yum to CentOS Yum and Repos,  Written by Licess"
echo "========================================================================="
 
# uninstall rhel yum
echo "Uninstall Rhel Yum......"
rpm -qa|grep yum|xargs rpm -e --nodeps
# delete old rpm
#echo "Clean old cache......"
#rm -rf python-iniparse-0.3.1-2.1.el6.noarch.rpm
#rm -rf yum-metadata-parser-1.1.2-14.1.el6.i686.rpm
#rm -rf yum-3.2.27-14.el6.centos.noarch.rpm
#rm -rf yum-plugin-fastestmirror-1.1.26-11.el6.noarch.rpm
 
# download CentOS Yum
echo "Download Python-iniparse......"
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/python-iniparse-0.2.3-4.el5.noarch.rpm  
echo "Download yum-metadata-parse......"
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-metadata-parser-1.1.2-3.el5.centos.x86_64.rpm 
echo "Download yum......"
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-3.2.22-39.el5.centos.noarch.rpm 
echo "Download yum fastmirror......"
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm

# install CentOS Yum
echo "Installing......"
rpm -ivh  python-iniparse-0.2.3-4.el5.noarch.rpm
rpm -ivh  yum-metadata-parser-1.1.2-3.el5.centos.x86_64.rpm
rpm -ivh  yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm yum-3.2.22-39.el5.centos.noarch.rpm

# replace repos
if [ -e /etc/yum.repos.d/rhel*.repo ] ; then
  mv /etc/yum.repos.d/rhel*.repo /etc/yum.repos.d/rhel.repo.bak 
fi

echo "[base]
name=CentOS-5 - Base - 163.com
baseurl=http://mirrors.163.com/centos/5/os/$BASE_ARCH/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=$BASE_ARCH&repo=os
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5

#released updates 
[updates]
name=CentOS-5 - Updates - 163.com
baseurl=http://mirrors.163.com/centos/5/updates/$BASE_ARCH/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=$BASE_ARCH&repo=updates
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5
 
#additional packages that may be useful
[extras]
name=CentOS-5 - Extras - 163.com
baseurl=http://mirrors.163.com/centos/5/extras/$BASE_ARCH/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=$BASE_ARCH&repo=extras
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-5 - Plus - 163.com
baseurl=http://mirrors.163.com/centos/5/centosplus/$BASE_ARCH/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=$BASE_ARCH&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5
 
#contrib - packages by Centos Users
[contrib]
name=CentOS-5 - Contrib - 163.com
baseurl=http://mirrors.163.com/centos/5/contrib/$BASE_ARCH/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=$BASE_ARCH&repo=contrib
gpgcheck=1
enabled=0
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5" >> /etc/yum.repos.d/CentOS5-Base-163.repo

echo "proxy=http://10.237.80.137:8080" >> /etc/yum.conf 
#####
yum clean all
yum makecache
 
echo "=========================================================================="
echo "You have successfully replace RedhatEnterprise Yum to CentOS yum and repos"
echo "=========================================================================="

