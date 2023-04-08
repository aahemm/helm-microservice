#!/bin/bash 

set -ex 
values_file_path=$1
helm install --debug --dry-run --values $values_file_path app ../
