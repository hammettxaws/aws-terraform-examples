#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2.service
systemctl enable apache2.service
echo "Gold $(hostname -f)" > /var/www/html/index.html

echo "end"
