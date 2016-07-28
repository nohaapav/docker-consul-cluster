#!/bin/bash

GC='\033[0;32m' #green color
NC='\033[0m' #no color

function log { echo -e "${GC}$1${NC}"; }

CONSUL_SERVERS=("consul0" "consul1" "consul2")

LEADER=true
LEADER_IP=()
for i in "${CONSUL_SERVERS[@]}"; do
        log "Creating $i machine..."
        docker-machine create --driver virtualbox --virtualbox-memory 512 $i
        eval "$(docker-machine env $i)"
        consul_ip=$(docker-machine ip $i)
        
        log "Running $i[$consul_ip] in server mode..."
        if $LEADER ;
        then
        docker run -d -h "$i" \
                   -p "8300:8300" \
                   -p "8301:8301" \
                   -p "8301:8301/udp" \
                   -p "8302:8302" \
                   -p "8302:8302/udp" \
                   -p "8400:8400" \
                   -p "8500:8500" \
                   gliderlabs/consul-server -server -advertise=$consul_ip -bootstrap-expect=${#CONSUL_SERVERS[@]}
        LEADER=false
        LEADER_IP=$consul_ip
        else
        docker run -d -h "$i" \
                   -p "8300:8300" \
                   -p "8301:8301" \
                   -p "8301:8301/udp" \
                   -p "8302:8302" \
                   -p "8302:8302/udp" \
                   -p "8400:8400" \
                   -p "8500:8500" \
                   gliderlabs/consul-server -server -advertise=$consul_ip -join=$LEADER_IP
        fi
done
