# Docker_DNS_Fix_Firewall_Hypervisor

The Docker-Deamon has problems with name resolution behind a hypervisor or a firewall. 
Post-Installation DNS-Fix for Docker-Deamons behind a hypervisor or a firewall.
You have to execute this script as root on the VM.

## Disclaimer
Please use this script only, if you know what you are doing. Using it at your own risk.

## Firewall
Dont forget to edit /etc/ufw/user.rules
```
 ### tuple ### allow any 53 0.0.0.0/0 any 172.18.0.0/16 in
 -A ufw-user-input -p tcp --dport 53 -s 172.18.0.0/16 -j ACCEPT # Docker Network
 -A ufw-user-input -p udp --dport 53 -s 172.18.0.0/16 -j ACCEPT # Docker Network
 -A ufw-user-input -p tcp --dport 53 -s XXX.XXX.XXX.XXX/24 -j ACCEPT # Network ID
 -A ufw-user-input -p udp --dport 53 -s XXX.XXX.XXX.XXX/24 -j ACCEPT # Network ID
```
