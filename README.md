# cf-ddns
**使用方法：**
```bash
wget https://github.com/mugoc/cf-ddns/raw/main/cf-ddns.sh && chmod +x cf-ddns.sh
```
**vi或文本编辑器修改一下参数：**</br>
```bash
Zone_ID=""        # 概况中的Zone_ID</br>
Email=""          # CloudFlare注册邮箱</br>
Key=""            # Global Key</br>
Records_NAME=""   # 需要更新IP的域名</br>
```

修改完成后保存

**命令行下添加一行计划任务：**<br>

crontab -e
```bash
*/1 * * * * "/root/cf-ddns-1.sh" > /dev/null   # 此处双引号中路径为脚本路径
```
计划任务每1分钟执行一次更新IP

脚本默认不支持`IPV6`，如有需要，请`自行魔改`
