#!/bin/bash
#安装所需
yum install wget -y
yum install unzip -y
yum install screen -y
sudo yum install pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc -y
sudo yum update nss -y
pip3 install fake_useragent
pip3 install simplejson
cd /root
#下载chrome
wget https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/706915/chrome-linux.zip
unzip chrome-linux.zip && sleep 5 && mv chrome-linux /root/chrome &&rm -f chrome-linux.zip
#下载githua
wget https://github.com/ping-0day/autoscan/archive/refs/heads/main.zip
unzip main.zip
unzip autoscan-main/crawlergo_x_XRAY.zip
chmod +x autoscan-main/*
chmod +x crawlergo_x_XRAY/crawlergo
rm -rf main.zip
#移动文件至指定位置
mv autoscan-main/xray /usr/bin/ && mv autoscan-main/httpx /usr/bin/ && mv autoscan-main/subfinder /usr/bin/ && mv autoscan-main/nuclei /usr/bin/ && mv autoscan-main/naabu /usr/bin/ && mv autoscan-main/anew /usr/bin/ && mv autoscan-main/notify /usr/bin/
echo test > /root/alltargets.txtls
mv autoscan-main/config.xray.yaml /root/config.yaml
mv autoscan-main/start.sh /root/
mv autoscan-main/launcher.py crawlergo_x_XRAY/
mv autoscan-main/notify.py /root/
mv autoscan-main/ping.py /root/
subfinder
notify
mv autoscan-main/config.yaml /root/.config/subfinder/config.yaml -f
mv autoscan-main/provider-config.yaml /root/.config/notify/provider-config.yaml -f
#清理
rm -rf main.zip && rm -rf __MACOSX && rm -rf autoscan-main