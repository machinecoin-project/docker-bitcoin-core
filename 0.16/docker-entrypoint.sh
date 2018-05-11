#!/bin/bash

set -exuo pipefail

MACHINECOIN_DIR=/machinecoin
MACHINECOIN_CONF=${MACHINECOIN_DIR}/machinecoin.conf

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.

if [ ! -e "${MACHINECOIN_CONF}" ]; then
  cat >${MACHINECOIN_CONF} <<EOF
# For documentation on the config file, see
#
# the bitcoin source:
#   https://github.com/bitcoin/bitcoin/blob/master/contrib/debian/examples/bitcoin.conf
# the wiki:
#   https://en.bitcoin.it/wiki/Running_Bitcoin
# server=1 tells Bitcoin-Qt and bitcoind to accept JSON-RPC commands
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
fi

cron start

if [ $# -eq 0 ]; then
  exec machinecoind -datadir=${MACHINECOIN_DIR} -conf=${MACHINECOIN_CONF}
else
  exec "$@"
fi