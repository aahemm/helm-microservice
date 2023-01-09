#!/bin/bash
set -ex 
if [ -z $1 ] 
then 
    echo "Please provide the release"
    exit 1
fi 

release=$1
url="https://github.com/aahemm/helm-microservice/releases/download/v$release/app-$release.tgz"
helm repo index ./ --merge index.yaml --url $url  
