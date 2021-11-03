#!/bin/bash

echo -e "\033[32m 安装所需依赖 \033[0m"
apt install jq curl wget -y 2>&1 > /dev/null 
yum install jq curl wget -y &> /dev/null 
yum install -y wget bind-utils &> /dev/null  #为centos系列安装依赖
apt install -y wget dnsutils  &> /dev/null   #为debain系列安装依赖
echo -e "\033[32m 依赖安装完成 \033[0m"
wget -P /usr/bin https://github.com/mugoc/cf-ddns/raw/main/cf-ddns-1.sh && chmod +x /usr/bin/cf-ddns-1.sh
wget -P /etc https://github.com/mugoc/cf-ddns/raw/main/cf-ddns-1-config.json 
echo -e "\033[32m 增加定时任务 \033[0m"
echo "*/1 * * * * root /usr/bin/cf-ddns-1.sh > /dev/null" >> /etc/crontab
echo -e "\033[32m 请vi 修改/etc/cf-ddns-1-config.json \033[0m"
