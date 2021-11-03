#!/bin/bash

Zone_ID=""			# 概况中的Zone_ID
Email=""			# CloudFlare注册邮箱
Key=""				# Global Key
Records_NAME=""		# 需要更新IP的域名
ip_file="ipv4.txt" 

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
echo "当前IP：${IPV4}"

if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
        if [ ${IPV4} == ${old_ip} ]; then
	        echo "IP has not changed."
	        exit 0
	fi
fi

updata=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${Zone_ID}/dns_records/${Records_ID}" \
     -H "X-Auth-Email: ${Email}" \
     -H "X-Auth-Key: ${Key}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${Records_NAME}'","content":"'${IPV4}'","ttl":60,"proxied":false}')

echo "${IPV4}">ipv4.txt
echo "IP更新完成：${Records_NAME}=>${IPV4}"
