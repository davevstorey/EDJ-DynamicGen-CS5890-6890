#!/bin/bash

apt-get update
apt-get install -y pkg-config
apt-get install -y python3-dev

cd /home/security/EDJ-DynamicGen-CS5890-6890/benchmarks/libxml2
tar -xvf libxml2-2.13.0.tar.xz
cd libxml2-2.13.0
export CC="afl-cc -fPIC -lshmQueue"
export CXX="afl-c++ -fPIC -lshmQueue"

./configure --enable-shared=no
make
