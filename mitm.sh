#!/bin/bash

set -e

usage () {
	echo "Usage: $0 {enable|disable}"
	exit 1
}

case "$1" in
	enable)
		sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 8080
		sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j REDIRECT --to-port 8080
	;;
	disable)
		sudo iptables -t nat -D PREROUTING 1
		sudo iptables -t nat -D PREROUTING 1
		;;
	*)
		usage
		;;
esac

exit 0

