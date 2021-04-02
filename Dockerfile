# Build
FROM golang:latest as build
WORKDIR /go/src/github.com/ypelud/test-mutating-webhook
COPY *.go .
COPY go.mod .
RUN go mod tidy \
  && CGO_ENABLED=0 GOARM=7 GOARCH=amd64 \
  go build -a -installsuffix cgo --ldflags '-w' -o webhook .


# image
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/ypelud/test-mutating-webhook/webhook .
CMD ["./webhook"]
