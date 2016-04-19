#!/bin/bash
#Rudimentary script to restore from cache

CACHE_FILE=/home/vagrant/cache.tar.gz
if [[ ! -f ${CACHE_FILE} ]]; then
    echo "Could not find cache directory. Proceeding without it."
    return
fi
mkdir -p ${CACHE_DIR}
cd ${CACHE_DIR}
tar -zxvf ${CACHE_FILE} .


