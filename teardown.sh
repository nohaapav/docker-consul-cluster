#!/bin/bash

source logger.sh

log "Removing consul cluster..."
docker-machine ls -q --filter name=consul* | xargs docker-machine rm -y

