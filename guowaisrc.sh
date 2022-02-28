#!/bin/bash



# 使用chaospy，只下载有赏金资产数据

./chaospy.py --download-new

./chaospy.py --download-rewards  #下载所有赏金资产

#对下载的进行解压，使用awk把结果与上次的做对比，检测是否有新增

if ls | grep ".zip" &> /dev/null; then

	unzip '*.zip' &> /dev/null

	cat *.txt >> newdomains.md

	rm -f *.txt

	awk 'NR==FNR{lines[$0];next} !($0 in lines)' alltargets.txtls newdomains.md >> domains.txtls

	rm -f newdomains.md

	################################################################################## 发送新增资产手机通知


	echo "资产侦察结束 $(date +%F-%T),找到新域 $(wc -l < domains.txtls) 个" > temp.txt
    sleep 2
    python3 notify.py temp.txt



	################################################################################## 更新nuclei漏洞扫描模板

	#proxychains4 nuclei -silent -update

	#proxychains4 nuclei -silent -ut

	rm -f *.zip

	else

	echo "没有找到新程序"  > temp.txt
    sleep 2
    python3 notify.py temp.txt 

fi



##################################################################################

if [ -s domains.txtls ];then


sleep 2
echo "开始使用 naabu 对新增资产端口扫描"  > temp.txt
sleep 2
python3 notify.py temp.txt 

 naabu -stats -l domains.txtls -p 80,443,8080,2053,2087,2096,8443,2083,2086,2095,8880,2052,2082,3443,8791,8887,8888,444,9443,2443,10000,10001,8082,8444,20000,8081,8445,8446,8447 -silent -o open-domain.txtls &> /dev/null

 echo "端口扫描结束，开始使用httpx探测存活"  > temp.txt
 sleep 2
 python3 notify.py temp.txt


 httpx -silent -stats -l open-domain.txtls -fl 0 -mc 200,302,403,404,204,303,400,401 -o newurls.txtls &> /dev/null



  echo "httpx共找到存活资产 $(wc -l < newurls.txtls) 个" > temp.txt
  sleep 2
  python3 notify.py temp.txt



  cat newurls.txtls >new-active-$(date +%F-%T).txt #保存新增资产记录

  cat domains.txtls >> alltargets.txtls

  echo "已将存活资产存在加入到历史缓存 $(date +%F-%T)"  > temp.txt
  sleep 2
  python3 notify.py temp.txt



 rm -f domains.txtls



#使用nuclei，xray 扫描存活资产，并将漏洞结果发送到通知，并删除此次缓存文件，并结束

##################################################################################

        echo "开始使用 nuclei 对新增资产进行漏洞扫描"  > temp.txt
        sleep 2
        python3 notify.py temp.txt

        cat newurls.txtls | nuclei -rl 600 -bs 50 -c 30  -mhe 10 -ni -o res-all-vulnerability-results.txtls -stats -silent -severity critical,medium,high,low -es info

        sleep 2

        python3 notify.py res-all-vulnerability-results.txtls



        #使用xray扫描，记得配好webhook，不配就删掉这项，保存成文件也可以

        #echo "开始使用 xray 对新增资产进行漏洞扫描"  | notify -silent -provider telegram

        #xray_linux_amd64 webscan  --url-file newurls.txtls --webhook-output http://www.qq.com/webhook --html-output xray-new-$(date +%F-%T).html

        #echo "xray  漏洞扫描结束，xray漏洞报告请上服务器查看"  | notify -silent -provider telegram

        rm -f open-domain.txtls

        rm -f newurls.txtls



else

################################################################################## Send result to notify if no new domains found

        echo "没有新域 $(date +%F-%T)" > temp.txt
        sleep 2
        python3 notify.py temp.txt

fi