FROM ubuntu:18.10
LABEL maintainer="urielCh <admin@uriel.ovh>"

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"
# sed -i s@http://archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@ /etc/apt/sources.list &&\

RUN set -ex;\
 apt-get update;\
 apt-get install -y --no-install-recommends git curl ca-certificates apt-utils gnupg2 build-essential libxtst-dev libpng++-dev;\
 curl -sL https://deb.nodesource.com/setup_10.x | bash -;\
 apt-get install -y nodejs;\
 apt-get clean && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/*;
# apt update;\

RUN set -ex;\
 git clone https://github.com/UrielCh/webRobotJS;\
 cd webRobotJS;\
 rm -rf .git;\
 npm install; cd ..;\
 git clone https://github.com/UrielCh/zombie-plugin;\
 cd zombie-plugin;\
 rm -rf .git;\
 npm install;\
 npm install -g typescript browserify;\
 tsc -p .;\
 cp         ./built/client.js       ./dist/js/client.js;\
 browserify ./built/popup.js      > ./dist/js/popup.js;\
 browserify ./built/background.js > ./dist/js/background.js;\
 cd ..

# echo 'curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /opt/google-chrome-stable_current_amd64.deb' >> dl.sh &&\
RUN set -ex;\
 echo '#!/bin/bash' > /dl.sh;\
 echo 'cp -r /webRobotJS /opt' >> /dl.sh;\
 echo 'cp -r /zombie-plugin/dist /opt/plugin' >> /dl.sh;\
 echo 'cp /setup_10.x /opt' >> /dl.sh;\
 echo 'echo All Done' >> /dl.sh;\
 chmod +x /dl.sh

WORKDIR /opt
