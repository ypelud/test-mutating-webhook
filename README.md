# Test webhook

Create a MutatingAdmissionWebhook that add labels to Resource created/updated.

## Build docker

```bash
docker build -t webhook
```

## Build go

```bash
go mod tidy
go build -o webhook ./cmd
```

## Certificat

*TODO* automatisation cert

```shell
sh createcert.sh
```

## Execute go

```bash
./webhook \
    --tls-cert-file=$PWD/tmp/webhook.test-webhook.svc.crt \
    --tls-private-key-file=$PWD/tmp/webhook.test-webhook.svc.key \
    2>&1
```

