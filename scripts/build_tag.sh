#!/bin/bash

set -e

tag=$1

latest=$(tail -n1 tagged.versions)
image="clicia/h2o-http2-server:$tag"
docker build --no-cache --pull --tag $image https://github.com/lkwg82/h2o.docker.git#$tag 
docker push $image
if [[ "$latest" == "$tag" ]]; then
   docker tag clicia/h2o-http2-server:$latest lkwg82/h2o-http2-server:latest
   docker push clicia/h2o-http2-server:latest
   docker rmi clicia/h2o-http2-server:latest
fi
# cleanup local build cache
docker rmi $image
