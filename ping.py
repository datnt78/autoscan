import os, sys
from socket import gethostbyname

# DOMAIN= "domains.txt"
######利用dns过滤资产
def main():
    # domain.txt里面存储的是需要批量解析的域名列表，一行一个
    with open("domains.txtls", 'r') as f:
        for line in f.readlines():
            try:
                host = gethostbyname(line.strip('\n'))
            except Exception as e:
                with open('error.txt','a+') as ERR:  #error.txt为没有IP绑定的域名
                    ERR.write(line.strip()+ '\n')
            else:
                # result.txt里面存储的是批量解析后的结果，不用提前创建
                with open('result.txt', 'a+') as r:
                    r.write(line.strip('\n') +'\n')
                    #r.write(host + '\n')


if __name__ == '__main__':
    main()