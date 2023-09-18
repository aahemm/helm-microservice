#!/bin/bash 

set -ex 
values_file_path=$1
helm upgrade -i --debug  --values $values_file_path test-app ../
