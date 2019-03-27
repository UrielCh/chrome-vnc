#!/bin/sh
. /env.sh
/usr/bin/Xvfb :1 -screen 0 ${X11_W}x${X11_H}x24 +extension RANDR