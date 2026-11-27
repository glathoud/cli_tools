#!/usr/bin/env bash

# Provided under the Boost License, see file ./LICENSE
# Use at your own risk.

# Requirements: tun2socks installed
# See https://github.com/xjasonlyu/tun2socks

# For a first check whether EveryProxy works at all with your computer,
# edit /etc/environment, adding the lines below, log out, log back in.
# check:
# curl ifconfig.me
# browser ip2location.com
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
#
# Now the goal of the present script is (1) to precisely replace
# that cumbersome manoeuver above, with a direct command-line, and
# (2) to use EveryProxy in SOCKS5 mode seamlessly.
#
# Usage:
# 
# everyproxy_tun2socks.sh
#
# Normally EveryProxy's IP is directly recognized. If not, try
# passing it as first argument.
#
# Especially if the activated EveryProxy SOCKS5 shows several IPs,
# sometimes the the ping-based IP resolution below may give a
# non-192.168... IP - if that leads to issues try manually typing in
# the 192.168... one, e.g.:
# 
# everyproxy_tun2socks.sh 192.168.0.100

set -eu
#set -euo pipefail

#set -v

# ---------- Prepare

PHONE_IP=""
if [ $# -gt 0 ]; then
    echo "aaa"
    PHONE_IP="$1"
fi
if [ -z "$PHONE_IP" ]; then
    echo "bbb"
    PING_IP=$(ping -c1 -W1 every-proxy.local | head -1 | awk -F'[()]' '{print $2}')
    if [[ "$PING_IP" == "192.168."* ]]; then
        PHONE_IP="$PING_IP"
    fi
fi
if [ -z "$PHONE_IP" ]; then
    PHONE_IP="192.168.0.100"
    echo "ccc default PHONE_IP"
fi
echo "PHONE_IP: $PHONE_IP"

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

#not needed it you already have your own custom /etc/resolv.conf
# (see also further below)
#xxx RESOLV_CONF="/etc/resolv.conf"
#xxx echo "RESOLV_CONF: $RESOLV_CONF"
#xxx if [ ! -f "$RESOLV_CONF" ]; then exit 5; fi
#xxx RC_SAVE="${RESOLV_CONF}.save.$(date +%s.%N)"
#xxx echo "RC_SAVE: $RC_SAVE"
#xxx if [ -f "$RC_SAVE" ]; then exit 6; fi

# ---------- Put here only so that we see the verbosity above

if [[ "root" != $(whoami) ]]; then
    CODE=$(sudo "$0" "$@")
    exit $CODE
fi

# ---------- Setup

setup () {
    echo "setup begins"
    set -x

    # Create TUN interface
    ip tuntap add mode tun dev tun0
    ip addr add 198.18.0.1/15 dev tun0
    ip link set dev tun0 up

    # Protect proxy traffic from looping
    # In any case, with or without "via", keep it consistent with the corresponding cleanup below
    #ip route add "$PHONE_IP" via "$GATEWAY_IP" dev "$INTERFACE_NAME"
    ip route add "$PHONE_IP" dev "$INTERFACE_NAME"

    # Exclude loopback traffic from tun0
    ip route add 127.0.0.0/8 dev lo
    
    # Route all traffic through tun0
    ip route add 0.0.0.0/1 dev tun0
    ip route add 128.0.0.0/1 dev tun0

    # Update DNS to use the virtual DNS pool (prevents leaks)
    # Probably not needed it you already have your own custom /etc/resolv.conf
    #xxx cp "$RESOLV_CONF" "$RC_SAVE"
    #xxx sh -c "echo nameserver 198.18.0.1 > ${RESOLV_CONF}"
    #or
    #xxx sh -c "echo nameserver 8.8.8.8 > ${RESOLV_CONF}"
        
    set +x
    echo "setup ends"
}

cleanup () {
    echo "cleanup begins"
    set -x
    
    set +eu # make sure all run through - but frankly everything MUST work - in the worst case, reboot your computer

    ip route del 0.0.0.0/1 dev tun0
    ip route del 128.0.0.0/1 dev tun0

    ip route add 127.0.0.0/8 dev lo
    
    # Be consistent with the corresponding line in setup() above
    #ip route del "$PHONE_IP" via "$GATEWAY_IP" dev "$INTERFACE_NAME"
    ip route del "$PHONE_IP" dev "$INTERFACE_NAME"

    # Be consistent with the corresponding line in setup() above
    # Restore original DNS (replace with your actual DNS servers)
    #xxx mv "$RC_SAVE" "$RESOLV_CONF"
    
    # Remove TUN interface
    ip link set dev tun0 down
    ip tuntap del dev tun0 mode tun

    set +x
    echo "cleanup ends"
}

trap cleanup EXIT

setup

tun2socks --device tun0 --proxy socks5://${PHONE_IP}:1080

echo "$0 done"
