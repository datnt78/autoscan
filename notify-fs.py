
#-*-coding: utf-8 -*-
import requests,sys
import datetime
import logging
def push_wechat_group(content):
    #print('开始推送')
    # 这里修改为自己机器人的webhook地址
    resp = requests.post("https://open.feishu.cn/open-apis/bot/v2/hook/89bbf57b-7ea0-48c3-a808-b390b112e81c",json={"msg_type":"text","content":{"text":content}})
file=sys.argv[1]
with open(file) as f:
    data = f.read()
push_wechat_group(str(data))
