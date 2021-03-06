#!/bin/bash

set -e

function finish {
	local exitCode=$?

	echo "cleanup"
        docker image rm -f test-buddy >/dev/null
        docker kill $(cat .cid)
        rm -f .cid

	echo "---------"	
	if [ "$exitCode" == "0" ]; then
		echo "Test: SUCCESS"
	else
		docker logs $cid 
		echo "Test: failed"
		exit $exitCode
	fi
}
trap finish EXIT

# build image
cd ../..
echo -n "building image ... "
docker build -t test-h2o . #> /dev/null
echo ok
cd $OLDPWD

docker build -t test-buddy -f Dockerfile.test . >/dev/null

docker run --cidfile .cid --rm -d \
	--cap-drop ALL \
	--cap-add SETUID \
	--cap-add SETGID \
	--cap-add SYS_ADMIN \
	test-buddy
ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(cat .cid))

sleep 1

set -x

# tests
curl -v --connect-timeout 1 --fail http://$ip:8080 >/dev/null 2>&1

set +x
