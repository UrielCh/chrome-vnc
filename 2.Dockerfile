# docker rm -f chrome; docker build -f 2.Dockerfile -t urielch/chrome-vnc2 .; docker run -t -i -p 5900:5900 --name chrome urielch/chrome-vnc2;
FROM ubuntu:18.10
LABEL maintainer="urielCh <admin@uriel.ovh>"

ENV VNC_PASSWORD="" \
	DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

ADD res/setup_10.x /tmp/
# ADD res/google-chrome-stable_current_amd64.deb /tmp/
#  dpkg -i /tmp/google-chrome-stable_current_amd64.deb &&\
RUN \
 sed -i s@http://archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@ /etc/apt/sources.list &&\
 apt-get update && apt-get install -y --no-install-recommends apt-utils gnupg2 &&\
 cat /tmp/setup_10.x | sh - &&\
 apt-get update &&\
 apt-get install -y curl xvfb nodejs pulseaudio x11vnc xdg-utils libnss3 wget libnspr4 libcairo2 libatk1.0-0 fonts-liberation libappindicator3-1 libatk-bridge2.0-0 libpango-1.0-0 fluxbox wmctrl chromium-browser &&\
 apt-get clean &&\
 rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/setup_10.x

RUN useradd --create-home --groups pulse-access --password chrome chrome &&\
 { echo "chrome"; echo "chrome"; } | passwd chrome &&\
 chown -R chrome:chrome /home/chrome/

ADD /res/plugin /home/chrome/plugin
ADD /res/webRobotJS /home/chrome/webRobotJS
ADD conf/ /

# build from windows platform
RUN chmod +x /*.sh
USER chrome
EXPOSE 5900

# ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

ENTRYPOINT ["/chomevnc.sh"]
