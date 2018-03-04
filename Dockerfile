FROM golang:1.9-alpine as builder

ADD . /go/src/github.com/evildecay/etcdkeeper

RUN apk update \
    && apk add git \
    && apk add curl \	
    && cd /go/src/github.com/evildecay/etcdkeeper \
    && go get github.com/golang/dep/... \
    && dep ensure -update \
    && go build -o etcdkeeper.bin src/httpserver/httpserver.go

FROM alpine:3.7

ENV HOST="0.0.0.0"
ENV PORT="8080"
ENV NAME="request"

WORKDIR /etcdkeeper
COPY --from=builder /go/src/github.com/evildecay/etcdkeeper/etcdkeeper.bin .
ADD assets assets

EXPOSE ${PORT}

ENTRYPOINT ./etcdkeeper.bin -h $HOST -p $PORT -n $NAME
