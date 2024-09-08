#!/bin/bash

opt -enable-new-pm=0 -load LLVMCGpass.so -CGpass $1

dot -Tpng callgraph.dot -o callgraph.png
