#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname $0)"

ISTIO_QUIT_ENDPOINT=${ISTIO_QUIT_ENDPOINT:-"http://localhost:15020/quitquitquit"}
ISTIO_READY_ENDPOINT=${ISTIO_READY_ENDPOINT:-"http://localhost:15020/healthz/ready"}

waiting(){
  url=${1}
  until ${SCRIPT_DIR}/xh ${url} --check-status; do
    echo waiting for ${url}
    sleep 1;
  done
}

quitquitquit(){
  url=${1}
  ${SCRIPT_DIR}/xh POST ${url}
}

run(){
  exec $@
}

waiting ${ISTIO_READY_ENDPOINT}
quitquitquit ${ISTIO_QUIT_ENDPOINT}
run $@
