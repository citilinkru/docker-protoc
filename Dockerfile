FROM golang:1.13 as build

RUN PROTOC_GEN_GO_VERSION="v1.3.2" && \
        go get -d -u github.com/golang/protobuf/protoc-gen-go && \
        git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout $PROTOC_GEN_GO_VERSION && \
        go install github.com/golang/protobuf/protoc-gen-go

FROM alpine:3.10 as production
COPY --from=build /go/bin/protoc-gen-go /usr/local/bin/

RUN cd /tmp && \
        PROTOC_VERSION="3.9.1" && \
        PROTOC_GRPC_WEB_VERSION="1.0.6" && \
        apk add --no-cache --virtual .build-dependencies ca-certificates wget unzip git && \
        wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
        wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
        apk add glibc-2.30-r0.apk && \
        wget "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
        unzip "protoc-${PROTOC_VERSION}-linux-x86_64.zip" -d ./protoc && \
        cp ./protoc/bin/protoc /usr/bin/ && \
        chmod +x /usr/bin/protoc && \
        cp -R ./protoc/include/* /usr/local/include && \
        wget https://github.com/grpc/grpc-web/releases/download/${PROTOC_GRPC_WEB_VERSION}/protoc-gen-grpc-web-${PROTOC_GRPC_WEB_VERSION}-linux-x86_64 -O /usr/local/bin/protoc-gen-grpc-web && \
        chmod +x /usr/local/bin/protoc-gen-grpc-web && \
        apk del .build-dependencies && \
        rm -rf /tmp/*


