需提前安装nginx或apache进行测试:

网站根目录路径为：
]# ll /var/www/html/
code -> /tmp/pro-deploy-demo-e565c_2019-02-03-22-33

nginx配置如下：
root   /var/www/html/code;

git仓库路径如下：
]# ll /deploy/source-code/test/
index.html
README.md

包含脚本如下：
一键git自动化部署脚本
一键回滚最近版本脚本
一键选择回滚版本脚本
