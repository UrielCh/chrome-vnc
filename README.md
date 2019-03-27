# Chrome-vnc

A multi-arch Docker chome VNC

## Build Steps

### Build and download dependences

```bash 
# clean old files
sudo rm -rf res; mkdir -p res;
# 
docker build -f dep.Dockerfile -t urielch/build-plugin .
docker run --rm -i -v $(pwd)/res:/opt --name tmp-compiler urielch/build-plugin /dl.sh
ls -lh res
```

### Build and test images
```bash
docker build -f 1.Dockerfile  -t urielch/chrome-vnc:$(dpkg --print-architecture) .
docker run -p 5900:5900 --name chrome urielch/chrome-vnc:$(dpkg --print-architecture)
docker exec -it chrome bash
docker rm -f chrome
```


### Upload arch images

```bash
docker login
docker push urielch/chrome-vnc:$(dpkg --print-architecture)
```

### Update multiArch Docker tag

edit ~/.docker/config.json add:
```json
{
    "experimental": "enabled"
}
```

```bash
docker rmi urielch/chrome-vnc:latest
docker manifest inspect urielch/chrome-vnc:latest
docker manifest create --amend urielch/chrome-vnc:latest urielch/chrome-vnc:amd64 urielch/chrome-vnc:armhf
docker manifest --purge push urielch/chrome-vnc:latest
```

### Test multi arch image

```bash
docker pull urielch/chrome-vnc:latest
docker run -p 5900:5900 --name chrome urielch/chrome-vnc:latest
```

### Cleanup images

```bash
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
```

