#!/bin/bash

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save
service iptables start
chkconfig iptables on

sed 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
sed 's/kernel.sysrq = 0/kernel.sysrq = 1/' /etc/sysctl.conf

cat <<END >> /etc/sysctl.conf
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.proxy_arp = 0
END

wget -O /etc/yum.repos.d/openvz.repo http://download.openvz.org/openvz.repo
rpm --import http://download.openvz.org/RPM-GPG-Key-OpenVZ

yum update -y
yum install -y epel-release
yum install vzctl vzquota ploop perl-LockFile-Simple nginx certbot vim mc -y

#vz dump
rpm -Uvh  http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/cstream-2.7.4-3.el6.rf.x86_64.rpm
rpm -Uvh http://download.openvz.org/contrib/utils/vzdump/vzdump-1.2-4.noarch.rpm

service nginx start
chkconfig nginx on

reboot
