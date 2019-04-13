FROM golang:1.11 as builder

WORKDIR /root/
RUN go get golang.org/x/time/rate && \
    mkdir -p /go/src/github.com/snail007/ && \
    cd /go/src/github.com/snail007/ && \
    git clone https://github.com/snail007/goproxy.git && \
    cd goproxy && \
    sed -i 's@"proxy/@"github.com/snail007/goproxy/@g' config.go main.go services/*.go && \
    CGO_ENABLED=0 go get . && \
    cp auth-file  blocked  direct /go/bin


FROM alpine:latest
WORKDIR /root/
COPY --from=builder /go/bin/* /root/

ENTRYPOINT [ "./goproxy"]

