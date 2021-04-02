service=webhook
namespace=test-webhook
outdir=$PWD/tmp

rm -fr ${outdir}
mkdir -p ${outdir}
cd ${outdir}


# cat <<EOF >> csr.conf
# [req]
# req_extensions = v3_req
# distinguished_name = req_distinguished_name
# [req_distinguished_name]
# [ v3_req ]
# basicConstraints = CA:FALSE
# keyUsage = nonRepudiation, digitalSignature, keyEncipherment
# extendedKeyUsage = serverAuth
# subjectAltName = @alt_names
# [alt_names]
# DNS.1 = ${service}
# DNS.2 = ${service}.${namespace}
# DNS.3 = ${service}.${namespace}.svc
# EOF

openssl genrsa -out rootCA.key 4096

openssl req -x509 -new -nodes -key rootCA.key \
  -subj "/CN=webhoo.ca" \
  -sha256 -days 35600 -out rootCA.crt

openssl genrsa -out ${service}.${namespace}.svc.key 2048

openssl req -new -sha256 -days 36500  \
  -key ${service}.${namespace}.svc.key \
  -subj "/CN=${service}.${namespace}.svc" \
  -out ${service}.${namespace}.svc.csr

openssl x509 -req -in ${service}.${namespace}.svc.csr \
  -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -out ${service}.${namespace}.svc.crt -days 36500 -sha256

echo "caBundle"
cat rootCA.crt | base64
echo "tls.key"
cat ${service}.${namespace}.svc.crt | base64
echo "tls.crt"
cat ${service}.${namespace}.svc.key | base64
