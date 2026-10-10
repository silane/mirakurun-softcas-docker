#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=/usr/local/lib/libsobacas.so
exec /opt/bin/recpt1 "$@"
