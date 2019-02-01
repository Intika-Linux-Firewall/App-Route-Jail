#!/bin/bash

gcc -D_GNU_SOURCE -o newns ./newns.c
gcc -fPIC -c -o mark.o mark.c
gcc -shared -o mark.so mark.o -ldl
