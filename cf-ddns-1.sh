#!/bin/bash

Config_File="/etc/cf-ddns-1-config.json"
ip_file="/etc/cf-ddns-1-ipv4.txt" 

if [ ! -f ${Config_File} ]; then
	echo "Config file not found"
	exit 1
fi

Zone_ID=`cat ${Config_File} | jq .Zone_ID | sed 's/\"//g'`				# 概况中的Zone_ID
Email=`cat ${Config_File} | jq .Email | sed 's/\"//g'`					# CloudFlare注册邮箱
Key=`cat ${Config_File} | jq .Key | sed 's/\"//g'`					# Global Key
Records_NAME=`cat ${Config_File} | jq .Records_NAME | sed 's/\"//g'`		# 需要更新IP的域名

# 替换下方的zone_ID,X-Auth-Key,X-Auth-Email在命令行复制，并保存返回值，查找需要修改的域名，如muge.example.com
# 返回值中找到对应域名的IP，替换到下发的Records_ID
Records_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${Zone_ID}/dns_records" \
     -H "Content-Type:application/json" \
     -H "X-Auth-Key:${Key}" \
     -H "X-Auth-Email:${Email}" | grep -Po '(?<="id":")[^"]*' | head -1)
Records_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${Zone_ID}/dns_records?type=A&name=${Records_NAME}" \
        -H "X-Auth-Email: ${Email}" \
        -H "X-Auth-Key: ${Key}" \
        -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*')
# Records_ID=""		# 上述操作返回的ID

IPV4=$(curl -s ip.sb)
Remote_IP=$(host -t a  $Records_NAME|grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"|head -1)
echo "当前IP：${IPV4}"
echo "域名IP：${Remote_IP}"

if [[ ${IPV4} == ${Remote_IP} ]]; then
	echo "IP has not changed."
	exit 0
fi

#if [ -f $ip_file ]; then
#    old_ip=$(cat $ip_file)
#        if [[ ${IPV4} == ${old_ip} ]]; then
#	        echo "IP has not changed."
#	        exit 0
#	fi
#fi

updata=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${Zone_ID}/dns_records/${Records_ID}" \
     -H "X-Auth-Email: ${Email}" \
     -H "X-Auth-Key: ${Key}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${Records_NAME}'","content":"'${IPV4}'","ttl":60,"proxied":false}')

echo "${IPV4}">${ip_file}
echo "IP更新完成：${Records_NAME}=>${IPV4}"
