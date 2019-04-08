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
 optsDeps="iputils-ping net-tools apt-utils";\
 apt-get install -y xvfb fonts-takao pulseaudio supervisor x11vnc xdg-utils libnss3 libnspr4 libcairo2 libatk1.0-0 fonts-liberation libappindicator3-1 libatk-bridge2.0-0 libpango-1.0-0 wget $optsDeps chromium-browser;\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;
#  ca-certificates

#RUN set -ex;\
# apt-get update;\
# commonsDeps="curl wget";\
# optsDeps="iputils-ping net-tools apt-utils";\
# apt-get install -y $commonsDeps $optsDeps chromium-browser;\
# rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;

RUN set -ex;\
 echo setup node; \
 wget -qO- https://deb.nodesource.com/setup_10.x | /bin/bash -;\
 apt-get install -y nodejs;\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/*;

RUN  set -ex;\
 useradd --create-home --groups pulse-access --password chrome chrome;\
 { echo "chrome"; echo "chrome"; } | passwd chrome;\
 chown -R chrome:chrome /home/chrome/; \
 cd /home/chrome; \
 mkdir -p /home/chrome/plugin /home/chrome/webRobotJS; \
 wget -qO- https://github.com/UrielCh/zombie-plugin/releases/download/4.0.0/zombie-v4.0.0.tar.gz | tar xvz -C /home/chrome/plugin/; \
 wget -qO- https://github.com/UrielCh/webRobotJS/releases/download/v1.0.0/roboJsWeb-x86_64-node-v10.tar.gz | tar xvz -C /home/chrome/webRobotJS/;

# RUN apt-get install -y xvfb && echo rm -rf /tmp/*
# RUN apt-get update && apt-get install -y  && dpkg -i /tmp/google-chrome-stable_current_amd64.deb
ADD conf/ /
RUN chmod +x /*.sh
VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]