# cf-ddns

使用方法：

wget https://github.com/mugoc/cf-ddns/raw/main/cf-ddns.sh && chmod +x cf-ddns.sh

vi或文本编辑器修改一下参数：

Zone_ID=""			# 概况中的Zone_ID
Email=""			# CloudFlare注册邮箱
Key=""				# Global Key
Records_NAME=""		# 需要更新IP的域名

修改完成后保存

命令行下添加一行计划任务：
crontab -e
*/1 * * * * "/root/cf-ddns-1.sh" > /dev/null   # 此处双引号中路径为脚本路径
