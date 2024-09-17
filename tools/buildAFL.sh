#!/bin/bash

# Build Common Libraries
cd /home/security/EDJ-DynamicGen-CS5890-6890/Common/
make clean && make

# Build AFL++
cd /home/security/EDJ-DynamicGen-CS5890-6890/AFLplusplus/
make source-only


