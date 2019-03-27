# chrome-vnc
docker chome VNC

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
docker manifest push urielch/chrome-vnc:latest
```

```bash
docker pull urielch/chrome-vnc:latest
```
