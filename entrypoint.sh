#!/bin/sh -

set -e

script_dir="$(dirname $0)"
istio_quit_endpoint=${ISTIO_QUIT_ENDPOINT:-"http://localhost:15020/quitquitquit"}
istio_ready_endpoint=${ISTIO_READY_ENDPOINT:-"http://localhost:15020/healthz/ready"}

waiting_for_istio(){
  url=${1}
  until ${script_dir}/xh ${istio_ready_endpoint} --check-status; do
    echo waiting for ${istio_ready_endpoint}
    sleep 1;
  done
}

quitquitquit(){
  ${script_dir}/xh POST ${istio_quit_endpoint}
}

waiting_for_istio
/bin/sh << EOF
$@
EOF
quitquitquit
