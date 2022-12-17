if [ ! -d "certs" ]
then
  mkdir -p certs
  openssl req -x509 -newkey rsa:4096 -days 365 \
  -nodes -sha256 -keyout certs/private.key -out certs/public.crt \
  -subj "/CN=storm-webdav-webdav-ns.apps.cnsa.cr.cnaf.infn.it" \
  -addext "subjectAltName = DNS:storm-webdav-webdav-ns.apps.cnsa.cr.cnaf.infn.it"
  cp certs/public.crt certs/ca.crt
fi
kubectl create secret generic \
 tls-ssl-storm-webdav \
 -n webdav-ns \
 --from-file=./certs/private.key \
 --from-file=./certs/public.crt \
 --from-file=./certs/ca.crt
