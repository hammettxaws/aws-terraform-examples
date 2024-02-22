#!/bin/bash
apt update -y
apt install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "Gold $(hostname -f)" > /var/www/html/index.html
