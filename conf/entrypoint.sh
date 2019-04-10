#!/bin/sh
echo Knowns env variables: X11_W, X11_H, EXTRA_CHROME_OPTION, URL, PASSWORD, EVAL_URL
echo Knowns secret: URL, vncpasswd
echo 

set -e
. ./env.sh
# VNC default no password
export X11VNC_AUTH="-nopw"

#touch /opt/vncpasswd
#echo "chrome" | vncpasswd -f > /opt/vncpasswd

# look for VNC password file in order (first match is used)
for passwd_file in /home/chrome/.vnc/passwd /run/secrets/vncpasswd; do
  if [ -f ${passwd_file} ]; then
    export X11VNC_AUTH="-rfbauth ${passwd_file}"
    break
  fi
done

# override above if VNC_PASSWORD env var is set (insecure!)
if [ "$PASSWORD" != "" ]; then
  echo $PASSWORD > /tmp/password
  export X11VNC_AUTH="-rfbauth /tmp/password"
  # export X11VNC_AUTH="-passwd $PASSWORD"
fi

exec "$@"
