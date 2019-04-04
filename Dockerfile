FROM ubuntu:18.10
LABEL maintainer="urielCh <admin@uriel.ovh>"

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# sed -i s@http://archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@ /etc/apt/sources.list;\

RUN set -ex;\
 fetchDeps="git ca-certificates openssl apt-utils gnupg2 build-essential libxtst-dev libpng++-dev";\
 apt-get update;\
 apt-get upgrade -y;\
 apt-get install -y --no-install-recommends $fetchDeps curl;\
 curl -s https://deb.nodesource.com/setup_10.x -o /setup_10.x;\
 chmod +x /setup_10.x && /setup_10.x;\
 apt-get install -y nodejs;\
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
 cd ..;\
 cp -r /webRobotJS /opt;\
 cp -r /zombie-plugin/dist /opt/plugin; \
 apt-get install -y curl xvfb nodejs fonts-takao pulseaudio supervisor x11vnc xdg-utils libnss3 wget libnspr4 libcairo2 libatk1.0-0 fonts-liberation libappindicator3-1 libatk-bridge2.0-0 libpango-1.0-0 chromium-browser;\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*

RUN  set -ex;\
 useradd --create-home --groups pulse-access --password chrome chrome;\
 { echo "chrome"; echo "chrome"; } | passwd chrome;\
 chown -R chrome:chrome /home/chrome/;\
 mv /opt/plugin /home/chrome/plugin;\
 mv /opt/webRobotJS /home/chrome/webRobotJS

ADD conf/ /

# RUN apt-get install -y xvfb && echo rm -rf /tmp/*
#RUN apt-get update && apt-get install -y  && dpkg -i /tmp/google-chrome-stable_current_amd64.deb
ADD conf/ /
RUN chmod +x /*.sh
VOLUME ["/home/chrome"]
EXPOSE 5900
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
