FROM ubuntu:18.10
LABEL maintainer="urielCh <admin@uriel.ovh>"

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# sed -i s@http://archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@ /etc/apt/sources.list;\

RUN set -ex;\
 apt-get update;\
 echo ;\
 echo installing other packages;\
 echo ;\
 apt-get install -y xvfb fonts-takao pulseaudio supervisor x11vnc xdg-utils libnss3 libnspr4 libcairo2 libatk1.0-0 fonts-liberation libappindicator3-1 libatk-bridge2.0-0 libpango-1.0-0;\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;

RUN set -ex;\
 apt-get update;\
 echo ;\
 echo installing other packages 2;\
 echo ;\
 commonsDeps="curl wget";\
 optsDeps="iputils-ping net-tools";\
 apt-get install -y $commonsDeps $optsDeps chromium-browser;\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;

RUN set -ex;\
 apt-get update;\
 fetchDeps="git ca-certificates openssl apt-utils gnupg2 build-essential libxtst-dev libpng++-dev";\
 apt-get install -y --no-install-recommends $fetchDeps $commonsDeps;\
 curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
 apt-get install -y nodejs;\
 echo ;\
 echo building webRobotJS;\
 echo ;\
 git clone https://github.com/UrielCh/webRobotJS /opt/webRobotJS;\
 cd /opt/webRobotJS;\
 rm -rf .git;\
 npm install;\
 echo ;\
 echo building chrome plugin;\
 echo ;\
 git clone https://github.com/UrielCh/zombie-plugin /tmp/zombie-plugin; \
 cd /tmp/zombie-plugin;\
 npm install -g typescript browserify;\
 npm install;\
 tsc -p .;\
 cp         ./built/client.js       ./dist/js/client.js;\
 browserify ./built/popup.js      > ./dist/js/popup.js;\
 browserify ./built/background.js > ./dist/js/background.js;\
 mv /tmp/zombie-plugin/dist /opt/plugin;\
 cd /;\
 rm -rf /tmp/zombie-plugin;\
 echo ;\
 echo cleaning;\
 echo ;\
 npm -g uninstall typescript browserify;\
 apt-get purge -y --auto-remove $fetchDeps; \
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;

RUN  set -ex;\
 useradd --create-home --groups pulse-access --password chrome chrome;\
 { echo "chrome"; echo "chrome"; } | passwd chrome;\
 chown -R chrome:chrome /home/chrome/;\
 mv /opt/plugin /home/chrome/plugin;\
 mv /opt/webRobotJS /home/chrome/webRobotJS

# RUN apt-get install -y xvfb && echo rm -rf /tmp/*
# RUN apt-get update && apt-get install -y  && dpkg -i /tmp/google-chrome-stable_current_amd64.deb
ADD conf/ /
RUN chmod +x /*.sh
VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
