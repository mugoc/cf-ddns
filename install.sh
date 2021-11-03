#!/bin/bash

echo -e "\033[32m 安装所需依赖 \033[0m"
apt install jq curl wget -y > /dev/null
yum install jq curl wget -y > /dev/null
echo -e "\033[32m 安装完成 \033[0m"
wget https://github.com/mugoc/cf-ddns/raw/main/cf-ddns-1.sh > /dev/null
wget https://github.com/mugoc/cf-ddns/raw/main/cf-ddns-1-config.json > /dev/null
chmod +x cf-ddns-1.sh
mv cf-ddns-1.sh /usr/bin
mv cf-ddns-1-config.json /etc
echo -e "\033[32m 增加定时任务 \033[0m"
echo "*/1 * * * * root /usr/bin/cf-ddns-1.sh > /dev/null" >> /etc/crontab
echo "\033[32m 请vi 修改/etc/cf-ddns-1-config.json \033[0m"
