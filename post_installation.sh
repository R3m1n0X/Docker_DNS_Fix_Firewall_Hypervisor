#!/bin/sh

#
# Please use this script only, if you know what you are doing. Using it at your own risk.
#
# Post-Installation DNS-Fix for Docker-Deamons behind a hypervisor or a firewall.
# You have to execute this script as root on the VM
#
# Dont forget to edit /etc/ufw/user.rules
#
# ### tuple ### allow any 53 0.0.0.0/0 any 172.18.0.0/16 in
# -A ufw-user-input -p tcp --dport 53 -s 172.18.0.0/16 -j ACCEPT # Docker Network
# -A ufw-user-input -p udp --dport 53 -s 172.18.0.0/16 -j ACCEPT # Docker Network
# -A ufw-user-input -p tcp --dport 53 -s XXX.XXX.XXX.XXX/24 -j ACCEPT # Network ID
# -A ufw-user-input -p udp --dport 53 -s XXX.XXX.XXX.XXX/24 -j ACCEPT # Network ID
#
# by Marvin Beckmann

dns_server=$(ip -4 addr show "$(ip -4 route list 0/0 | awk '{print $5}')" | grep inet | awk '{print $2}' | awk -F'/' '{print $1}')

install_dnsmasq(){
    apt install dnsmasq
}

create_dnsmasq_conf(){
cat << EOF > /etc/dnsmasq.conf
server=8.8.8.8
server=8.8.4.4
EOF
}

create_docker_conf(){
cat << EOF > /etc/systemd/system/docker.service.d/dockeroptions.conf
[Service]
ExecStart=/usr/bin/dockerd -s btrfs --dns ${dns_server} --log-driver=syslog --cluster-store=etcd://127.0.0.1:4001 --cluster-advertise=127.0.0.1:4001
Restart=always
EOF
}

execute (){
    install_dnsmasq
    create_dnsmasq_conf
    create_docker_conf
    service docker restart
    service dnsmasq restart
    service ufw restart
}

execute
