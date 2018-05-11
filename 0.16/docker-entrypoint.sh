#!/bin/bash

set -exuo pipefail

mkdir -p "$MACHINECOIN_DATA"
chmod 700 "$MACHINECOIN_DATA"
chown -R machinecoin "$MACHINECOIN_DATA"

cat <<-EOF > "$MACHINECOIN_DATA/machinecoin.conf"
server=1

rpcuser=${MACHINECOIN_RPCUSER:-machinecoin}
rpcpassword=${MACHINECOIN_RPCPASSWORD:-changemeplzasap}
rpcallowip=${MACHINECOIN_RPCALLOWIP:-127.0.0.1}

printtoconsole=${MACHINECOIN_PRINTTOCONSOLE:-1}

masternode=${MACHINECOIN_MASTERNODE:-0}
masternodeprivkey=${MACHINECOIN_MASTERNODE_KEY:-0}
externalip=${MACHINECOIN_MASTERNODE_IP:-0}:40333

txindex=1
EOF

if [ $# -eq 0 ]; then
  exec machinecoind -datadir=${MACHINECOIN_DATA} "${MACHINECOIN_RUN_ARGS}"
else
  exec "$@"
fi
cron start
