docker-protoc
=============
> Docker wrapper over protoc utility

How to use
----------

### Golang example
```bash
docker run --rm -v "$(pwd)":/data citilink/docker-protoc protoc -I=/data/ *.proto --go_out=plugins=grpc:/data/
```

### PHP example
```bash
docker run --rm -v "$(pwd)":/data citilink/docker-protoc protoc -I=/data/ *.proto --php_out=/data/
```

### JS (GRPC-Web) example
```bash
docker run --rm -v "$(pwd)":/data citilink/docker-protoc protoc -I=./data *.proto --js_out=import_style=commonjs:./data --grpc-web_out=import_style=commonjs,mode=grpcwebtext:./data
```

Tags
----

 * **2.0.0**: includes: `protoc` (v3.12.3); `protoc-gen-grpc-web` (v1.2.0); `protoc-gen-go` (v1.4.2)
 * **1.0.1**: includes: `protoc` (v3.9.1); `protoc-gen-grpc-web` (v1.0.6); `protoc-gen-go` (v1.3.2)
