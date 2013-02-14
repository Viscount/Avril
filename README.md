##设置说明

###Hosts添加

> 127.0.0.1 www.avril.com

###配置端口转发

> sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -d 127.0.0.0/8 -j REDIRECT --to-port 3000

