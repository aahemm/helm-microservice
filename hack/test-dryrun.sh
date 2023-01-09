#!/bin/bash 

values_file_path=$1
helm install --debug --dry-run --values $values_file_path app ../
