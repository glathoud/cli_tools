#!/usr/bin/env bash

# For a first check whether EveryProxy works at all with your computer,
# edit /etc/environment, adding the lines below, log out, log back in.
# curl ifconfig.me
# etc.
#
# /etc/environment lines:
#   http_proxy=http://192.168.0.100:8080/
#   HTTP_PROXY=http://192.168.0.100:8080/
#   https_proxy=http://192.168.0.100:8080/
#   HTTPS_PROXY=http://192.168.0.100:8080/
#   no_proxy="localhost,127.0.0.1"
#   NO_PROXY="localhost,127.0.0.1"
#   # for socks might try: 
#   #all_proxy="socks5://192.168.0.100:1080"
#   #ALL_PROXY="socks5://192.168.0.100:1080"



set -eu
#set -euo pipefail

set -v

# ---------- Prepare

PHONE_IP=""
if [ $# -gt 0 ]; then
    echo "aaa"
    PHONE_IP="$1"
fi
if [ -z "$PHONE_IP" ]; then
    echo "bbb"
    PHONE_IP=$(ping -c1 -W1 every-proxy.local | head -1 | awk -F'[()]' '{print $2}')
    echo "bbb2 $?"
fi
echo "PHONE_IP: $PHONE_IP"
if [ -z "$PHONE_IP" ]; then exit 1; fi

S_DFLT=$(ip route | grep default)
echo "S_DFLT: $S_DFLT"
if [ -z "$S_DFLT" ]; then exit 2; fi
# e.g.
# default via 192.168.0.1 dev enp0s31f6 proto dhcp src 192.168.0.106 metric 100 
GATEWAY_IP=$(echo "$S_DFLT" | cut -d ' ' -f 3,3)
INTERFACE_NAME=$(echo "$S_DFLT" | cut -d ' ' -f 5,5)
echo "GATEWAY_IP: $GATEWAY_IP"
echo "INTERFACE_NAME: $INTERFACE_NAME"
if [ -z "$GATEWAY_IP" ]; then exit 3; fi
if [ -z "$INTERFACE_NAME" ]; then exit 4; fi

RESOLV_CONF="/etc/resolv.conf"
echo "RESOLV_CONF: $RESOLV_CONF"
if [ ! -f "$RESOLV_CONF" ]; then exit 5; fi
RC_SAVE="${RESOLV_CONF}.save.$(date +%s.%N)"
echo "RC_SAVE: $RC_SAVE"
if [ -f "$RC_SAVE" ]; then exit 6; fi

# ---------- Setup

setup () {
    echo "setup begins"
    set -x

    # Create TUN interface
    sudo ip tuntap add mode tun dev tun0
    sudo ip addr add 198.18.0.1/15 dev tun0
    sudo ip link set dev tun0 up

    # Protect proxy traffic from looping
    # In any case, with or without "via", keep it consistent with the corresponding cleanup below
    #sudo ip route add "$PHONE_IP" via "$GATEWAY_IP" dev "$INTERFACE_NAME"
    sudo ip route add "$PHONE_IP" dev "$INTERFACE_NAME"

    # Route all traffic through tun0
    sudo ip route add 0.0.0.0/1 dev tun0
    sudo ip route add 128.0.0.0/1 dev tun0

    # Update DNS to use the virtual DNS pool (prevents leaks)
    # Probably not needed it you already have your own custom /etc/resolv.conf
    #xxx sudo cp "$RESOLV_CONF" "$RC_SAVE"
    #xxx sudo sh -c "echo nameserver 198.18.0.1 > ${RESOLV_CONF}"
    #or
    #xxx sudo sh -c "echo nameserver 8.8.8.8 > ${RESOLV_CONF}"
        
    set +x
    echo "setup ends"
}

cleanup () {
    echo "cleanup begins"
    set -x
    
    set +eu # make sure all run through - but frankly everything MUST work - in the worst case, reboot your computer

    sudo ip route del 0.0.0.0/1 dev tun0
    sudo ip route del 128.0.0.0/1 dev tun0

    # Be consistent with the corresponding line in setup() above
    #sudo ip route del "$PHONE_IP" via "$GATEWAY_IP" dev "$INTERFACE_NAME"
    sudo ip route del "$PHONE_IP" dev "$INTERFACE_NAME"

    # Be consistent with the corresponding line in setup() above
    # Restore original DNS (replace with your actual DNS servers)
    #xxx sudo mv "$RC_SAVE" "$RESOLV_CONF"
    
    # Remove TUN interface
    sudo ip link set dev tun0 down
    sudo ip tuntap del dev tun0 mode tun

    set +x
    echo "cleanup ends"
}

trap cleanup EXIT

setup

sudo tun2socks --device tun0 --proxy socks5://${PHONE_IP}:1080

echo "$0 done"
