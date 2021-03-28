#!/bin/bash

responseHttp=$(curl --write-out '%{http_code}' --silent --output /dev/null http://localhost:880)
responseHttps=$(curl --write-out '%{http_code}' --silent --output /dev/null --insecure https://localhost:4443)
if [ $responseHttp != 200 ] || [ $responseHttps != 200 ]; then
  exit 1;
else
  echo "Nginx server is runing successfully ✅";
fi