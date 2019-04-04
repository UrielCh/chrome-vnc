#!/bin/sh
echo start xvfb.sh
echo  ${X11_W}x${X11_H}x16
. /env.sh
/usr/bin/Xvfb :1 -screen 0 ${X11_W}x${X11_H}x16 +extension RANDR
