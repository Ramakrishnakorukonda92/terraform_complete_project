#!/bin/bash
yum update -y
sudo amazon-linux-extras install nginx1
systemctl start nginx
systemctl enable nginx
sudo mkdir /usr/share/nginx/html/app1
sudo echo "<h1>hi from nginx</h1>" | sudo tee /usr/share/nginx/html/index.html
sudo echo "<h1>hi from nginx1</h1>" | sudo tee /usr/share/nginx/html/app1/index.html