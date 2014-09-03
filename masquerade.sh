#!/bin/bash

#set -x

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
hostapd_conf="${script_dir}/conf/hostapd.conf"
dnsmasq_file="dnsmasq_dapap.conf"
dnsmasq_conf="${script_dir}/conf/${dnsmasq_file}"

usage () {
	echo "Usage: $0 {enable|disable}"
	exit 1
}

case "$1" in
	enable)
		sudo ifconfig wlan0 up 10.254.74.1 netmask 255.255.255.0
		sleep 2;
		sudo sed -i "s:#DAEMON_CONF=\"\":DAEMON_CONF=\"${hostapd_conf}\":" /etc/default/hostapd
		sudo iptables -A FORWARD -o eth0 -i wlan0 -s 10.254.74.0/24 -m conntrack --ctstate NEW -j ACCEPT
		sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
		sudo iptables -t nat -F POSTROUTING
		sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
		sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
		sudo ln -s ${dnsmasq_conf} /etc/dnsmasq.d/
		sudo service hostapd start
		sudo service dnsmasq restart
	;;
	disable)
		sudo service hostapd stop
		sudo sed -i "s:DAEMON_CONF=\"${hostapd_conf}\":#DAEMON_CONF=\"\":" /etc/default/hostapd
		sudo rm /etc/dnsmasq.d/${dnsmasq_file}
		sudo service dnsmasq restart
		sudo sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"
		sudo iptables -D FORWARD 1
		sudo iptables -D FORWARD 1
		sudo iptables -t nat -D POSTROUTING 1
		sudo ifconfig wlan0 down
		;;
	*)
		usage
		;;
esac

exit 0

