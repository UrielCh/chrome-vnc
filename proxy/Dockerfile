FROM golang as builder
WORKDIR /root/
RUN FILE=proxy-$(go env GOOS)-$(go env GOARCH).tar.gz && \
    wget https://github.com/snail007/goproxy/releases/download/v7.3/$FILE -O $FILE && \
    tar -xvzf $FILE && \
    rm $FILE

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /root/* /root/
ENTRYPOINT [ "proxy" ]  
