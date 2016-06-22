#!/bin/bash -e
#
#

BASE_TAG="universe-build"

if [ "$http_proxy" != "" ]
then
   PROXY=" --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy"
   echo "Using your local proxy setting : $http_proxy"
   if [ "$no_proxy" != "" ]
   then
      PROXY="$PROXY --build-arg no_proxy=$no_proxy"
      echo "no_proxy : $http_proxy"
   fi
fi

if [ "$1" != "" ]
then
   TAG_NAME="$1"
else
   TAG_NAME="$BASE_TAG:test"
fi
TAG_ARG="-t $TAG_NAME"

if [ "$(echo "$TAG_NAME" | awk ' $1 ~ /\//')" = "" ]
then
   echo "Simply tagging to '$TAG_NAME'"
   PUSH=false
else
   echo "tagging to '$TAG_NAME'."
   PUSH=true
fi

echo "-------------------------"
set -x
[ $PUSH = true ] && sudo docker pull $TAG_NAME || echo "Building it from scratch"
sudo docker build $PROXY $TAG_ARG .
