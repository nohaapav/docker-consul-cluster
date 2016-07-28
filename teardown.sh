#!/bin/bash

GC='\033[0;32m' #green color
NC='\033[0m' #no color

function log { echo -e "${GC}$1${NC}"; }

log "Removing consul cluster..."
docker-machine ls -q --filter name=consul* | xargs docker-machine rm -y

