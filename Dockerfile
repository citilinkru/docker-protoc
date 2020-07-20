FROM golang:1.13 as build

RUN PROTOC_GEN_GO_VERSION="v1.4.2" && \
        go get -d -u github.com/golang/protobuf/protoc-gen-go && \
        git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout $PROTOC_GEN_GO_VERSION && \
        go install github.com/golang/protobuf/protoc-gen-go

FROM alpine:3.10 as production
COPY --from=build /go/bin/protoc-gen-go /usr/local/bin/

RUN cd /tmp && \
        PROTOC_VERSION="3.12.3" && \
        PROTOC_GRPC_WEB_VERSION="1.2.0" && \
        apk add --no-cache --virtual .build-dependencies ca-certificates wget unzip git && \
        wget -q -O /etc/apk/keys/sgerrand.rsa.pub "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" && \
        wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk" && \
        apk add glibc-2.30-r0.apk && \
        wget -q -O protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
        unzip protoc.zip -d ./protoc && \
        mv ./protoc/bin/protoc /usr/local/bin/ && \
        chmod +x /usr/local/bin/protoc && \
        mv ./protoc/include /usr/local/include && \
        wget -q -O /usr/local/bin/protoc-gen-grpc-web "https://github.com/grpc/grpc-web/releases/download/${PROTOC_GRPC_WEB_VERSION}/protoc-gen-grpc-web-${PROTOC_GRPC_WEB_VERSION}-linux-x86_64" && \
        chmod +x /usr/local/bin/protoc-gen-grpc-web && \
        apk del .build-dependencies && \
        rm -rf /tmp/*


