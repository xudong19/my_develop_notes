#!/usr/bin/env bash

IMAGENAME=my_py_image
CONTAINERNAME=my_py_workspace

docker build \
       --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa.pub)"  \
       -t $IMAGENAME .

docker run  \
       -it \
       -d \
       -p 1919:1919 \
       --name $CONTAINERNAME $IMAGENAME
