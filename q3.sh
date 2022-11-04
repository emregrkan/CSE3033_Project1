#!/bin/bash

# START main
command mkdir -p "writable"
command mv $(find -maxdepth 1 -type f -writable) "./writable"
#END
