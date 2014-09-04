#!/bin/bash

sudo sed -i "s/dns=dnsmasq/#dns=dnsmasq/" /etc/NetworkManager/NetworkManager.conf
sudo service network-manager restart
sudo apt-get install dnsmasq hostapd
