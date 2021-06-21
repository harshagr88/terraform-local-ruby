#!/bin/bash

set -e

CURRENT_DIR=`pwd`
BUILD_DIR="$CURRENT_DIR/http_server"

echo -e "Setting up local registry for storing docker images.."

echo "docker run -d -p 5000:5000 --restart=always --name registry registry:2"

docker run -d -p 5000:5000 --restart=always --name registry registry:2 2> /dev/null

if [ $? -eq 0 ]
then
  echo "Successfully created docker registry locally.."
  echo "Container ID: "
  docker ps -lq
else
  echo "Could not create registry locally" >&2
fi

echo "Building image..."
cd $BUILD_DIR
docker build . -t localhost:5000/http_server:latest

if [ $? -eq 0 ]
then
  echo "Successfully build docker image.."
  docker push localhost:5000/http_server:latest
else
  echo "Could not create docker image.." >&2
fi