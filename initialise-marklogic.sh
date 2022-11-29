docker run -d -it -p 8030:8000 -p 8031:8001 -p 8032:8002 -p 8035:8005 \
  -e MARKLOGIC_INIT=true \
  -e MARKLOGIC_ADMIN_USERNAME=admin \
  -e MARKLOGIC_ADMIN_PASSWORD=password \
  marklogicdb/marklogic-db:10.0-9.5-centos-1.0.0