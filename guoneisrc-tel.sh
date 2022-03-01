#!/bin/bash
#资产更新

echo "运行xray监听9999端口"
echo "xray webscan --listen 127.0.0.1:9999 --html-output proxy.html"
echo "nuclei更新完毕开始资产收集"  | notify -p telegram

#资产倒入
subfinder -silent -dL domain.txt -o domains.txt
echo "子域名收集完毕"  | notify -p telegram

cat domains.txt >> newdomains.md
rm -f domains.txt
awk 'NR==FNR{lines[$0];next} !($0 in lines)' alltargets.txtls newdomains.md >> domains.txtls #资产对比
rm -f newdomains.md
################################################################################## 发送新增资产手机通知
python3 ping.py #通过dns判断存活
mv result.txt domains.txtls -f
rm -f error.txt
echo "资产侦察结束 $(date +%F-%T),找到新域 $(wc -l < domains.txtls) 个"  | notify -p telegram


##################################################################################
if [ -s domains.txtls ];then
        echo "开始使用 naabu 对新增资产端口扫描"   | notify -p telegram
        
        naabu -stats -l domains.txtls -p 80,81,82,83,84,85,86,87,88,89,90,443,6379,7001,7002,7003,8000,8001,8002,8003,8004,8005,8006,8007,8008,8009,8080,8081,8082,8083,8084,8085,8086,8087,8088,8089,8090,8093,8443,8888,8889,8890,9080,9990,18080,9100,9443,7443,10443,8050,8060 -silent -o open-domain.txtls &> /dev/null
        echo "端口扫描结束，开始使用httpx探测存活"    | notify -p telegram
        
        httpx -silent -stats -l open-domain.txtls -fl 0 -mc 200,302,403,404,204,303,400,401 -o newurls.txtls &> /dev/null
        echo "httpx共找到存活资产 $(wc -l < newurls.txtls) 个"  | notify -p telegram
        
        cat newurls.txtls >new-active-$(date +%F-%T).txt #保存新增资产记录

        cat domains.txtls >> alltargets.txtls

        echo "已将存活资产存在加入到历史缓存 $(date +%F-%T)"  | notify -p telegram
        
        rm -f domains.txtls

#使用nuclei，xray 扫描存活资产，并将漏洞结果发送到通知，并删除此次缓存文件，并结束
        echo "开始使用 nuclei 对新增资产进行漏洞扫描"  | notify -p telegram
        
        cat newurls.txtls | nuclei -rl 100 -bs 20 -mhe 10 -ni  -t ./templates-main -o res-all-vulnerability-results.txtls -stats -silent -es info | notify -p telegram

        sleep 5
        echo "nuclei漏洞扫描结束"  | notify -p telegram
        
#xray 进行扫描
        echo "开始使用 xray 对新增资产进行漏洞扫描"   | notify -p telegram
        

        python3 /root/crawlergo_x_XRAY/launcher.py

        echo "crawlergo结束稍后查看xray报告"   | notify -p telegram
        
        rm -f open-domain.txtls
        rm -f newurls.txtls
else

################################################################################## Send result to notify if no new domains found

        echo "没有新域 $(date +%F-%T)" | notify -p telegram
        
fi