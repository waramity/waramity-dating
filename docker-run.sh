#!/bin/bash
app="docker.waramity-dating"
docker build -t ${app} .
docker run -d -p 56730:80 \
  --name=${app} \
  -v $PWD:/app ${app}
