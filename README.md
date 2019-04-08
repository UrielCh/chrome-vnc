# Chrome-vnc

A multi-arch Docker chome VNC

## Build Steps

### Build and test images

```sh
docker build -f ubuntu.Dockerfile -t urielch/chrome-vnc:ubuntu-$(dpkg --print-architecture) .
docker build -f alpine.Dockerfile -t urielch/chrome-vnc:alpine-$(dpkg --print-architecture) .
```

### try it on a hevy website

```sh
docker run -d --rm -p 5900:5900 -e EXTRA_CHROME_OPTION="--lang=fr-FR,fr" -e X11_W=1024 -e X11_H=768 -e LANG="fr_FR.UTF-8" -e LC_ALL="fr_FR.UTF-8" -e URL=https://maps.google.fr --name chrome-ubu urielch/chrome-vnc:ubuntu-$(dpkg --print-architecture)
docker run -d --rm -p 5901:5900 -e EXTRA_CHROME_OPTION="--lang=fr-FR,fr" -e X11_W=1024 -e X11_H=768 -e LANG="fr_FR.UTF-8" -e LC_ALL="fr_FR.UTF-8" -e URL=https://maps.google.fr --name chrome-alp urielch/chrome-vnc:alpine-$(dpkg --print-architecture)
```

```sh
xvnc4viewer 127.0.0.1:0 &
xvnc4viewer 127.0.0.1:1 &
```

### Upload arch images

```sh
docker login
docker push urielch/chrome-vnc:ubuntu-$(dpkg --print-architecture)
docker push urielch/chrome-vnc:alpine-$(dpkg --print-architecture)
```

### Update multiArch Docker tag

edit ~/.docker/config.json add:
```json
{
    "experimental": "enabled"
}
```

```sh
docker rmi urielch/chrome-vnc:latest
docker manifest inspect urielch/chrome-vnc:latest
docker manifest create --amend urielch/chrome-vnc:latest urielch/chrome-vnc:amd64 urielch/chrome-vnc:armhf
docker manifest --purge push urielch/chrome-vnc:latest
```

### Test multi arch image

```sh
docker pull urielch/chrome-vnc:latest
docker run -p 5900:5900 --name chrome urielch/chrome-vnc:latest
```

### Cleanup images

```sh
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
```

