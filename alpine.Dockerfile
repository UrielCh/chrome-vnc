FROM alpine:3.9
LABEL maintainer="urielCh <admin@uriel.ovh>"

RUN apk add --no-cache xvfb pulseaudio supervisor x11vnc xdg-utils wget chromium nodejs dbus ttf-dejavu

RUN set -ex;\
 adduser -D -u 1000 chrome pulse-access;\
 mkdir -p /home/chrome/plugin /home/chrome/webRobotJS; \
 wget -qO- https://github.com/UrielCh/zombie-plugin/releases/download/v4.0.5/zombie-v4.0.5.tar.gz | tar xvz -C /home/chrome/plugin/; \
 wget -qO- https://github.com/UrielCh/webRobotJS/releases/download/v1.0.0/robotJsWeb-$(uname -m)-node-v10.tar.gz | tar xvz -C /home/chrome/webRobotJS/;

ADD conf/ /
RUN chmod +x /*.sh
VOLUME ["/home/chrome"]

EXPOSE 5900
USER root

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
