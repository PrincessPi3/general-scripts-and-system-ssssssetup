#!/bin/bash
#Crowdsec Install and config
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
apt -y install crowdsec
truncate -s 0 /var/log/crowdsec.log
#configure bouncers as needed here https://hub.crowdsec.net/browse/#bouncers
apt -y install crowdsec-firewall-bouncer-iptables 
cscli collections install crowdsecurity/base-http-scenarios
cscli bouncers add php-bouncer
systemctl reload crowdsec
#cscli bouncers add <nginx-bouncer php-bouncer wordpress-bouncer cloudflare-bouncer> #as needed
# SAVE API KEY, THEY ARE UNRECOVERABLE
#for wordpress: install crowdsec plugin in admin panel
#   SAVE API KEY FROM INSTALL
#   add API key
#   LAPIU URL: http://localhost:8080
#for cpanel
#cscli scenarios install crowdsecurity/cpanel-bf

#unban an IP
#cscli decisions list
#cscli decisions delete --id <id number from list>
