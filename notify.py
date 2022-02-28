
#-*-coding: utf-8 -*-
import requests,sys
import datetime
import logging
def push_wechat_group(content):
    #print('开始推送')
    # 这里修改为自己机器人的webhook地址
    resp = requests.post("https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=1eb78f9d-cadf-4e2c-a967-3021c3d2469b",
                         json={"msgtype": "markdown",
                               "markdown": {"content": content}})
    print(resp.json()["errcode"])

    if resp.json()["errcode"] == 0:
        print('push wechat group success',resp.text)

    if resp.json()["errcode"] != 0:
        raise ValueError("push wechat group failed, %s" % resp.text)
file=sys.argv[1]
with open(file) as f:
    data = f.read()
push_wechat_group(str(data))
