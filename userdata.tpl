#!/bin/bash
sudo dnf update
sudo dnf install -y redis6

sudo sed -i '1i bind 0.0.0.0\nprotected-mode no\nport 6379' /etc/redis6/redis6.conf

sudo systemctl enable redis6
sudo systemctl start redis6