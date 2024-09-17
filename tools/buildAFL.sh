#!/bin/bash

# Build Common Libraries
cd /home/security/EDJ-DynamicGen-CS5890-6890/Common/
make clean && make

# Build AFL++
cd /home/security/EDJ-DynamicGen-CS5890-6890/AFLplusplus/
make source-only

# Update environment variables
NEW_PATH="PATH=\$PATH:/home/security/EDJ-DynamicGen-CS5890-6890/AFLplusplus/"
if ! grep -q "$NEW_PATH" ~/.bashrc; then
echo "export $NEW_PATH" | tee -a ~/.bashrc > /dev/null
else
echo "Path has already been updated"
fi


