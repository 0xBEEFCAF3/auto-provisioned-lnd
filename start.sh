#!/bin/bash
set -ex

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Expecting node name"
fi


# testnet or mainnet
network=$1
echo "[DEBUG] Starting to provision lnd"
echo "[DEBUG] Network: ${network}"

mkdir -p /root/.lnd
seed_location=/root/.lnd/seed.txt
wallet_pwd_location=/root/.lnd/wallet_pwd.txt
tls_cert_location=/root/.lnd/tls.cert
channel_back_up_location=/root/.lnd/data/chain/bitcoin/testnet/channel.backup

if [[ ! -f $seed_location ]]; then
    lndinit gen-seed > $seed_location
fi

if [[ ! -f $wallet_pwd_location ]]; then
    lndinit gen-password > $wallet_pwd_location
fi

# Create the wallet database with the given seed and password files. If the wallet already exists, we make sure we can actually unlock it with the given password file. This will take a few seconds in any case.
lndinit -v init-wallet \
    --secret-source=file \
    --file.seed=$seed_location \
    --file.wallet-password=$wallet_pwd_location \
    --init-file.output-wallet-dir=$HOME/.lnd/data/chain/bitcoin/$network \
    --init-file.validate-password
echo "[DEBUG] lnd Wallet initialized"

# Start lnd
lnd --configfile=/root/lnd.conf &
echo "[DEBUG] lnd Started"

# Wait for lnd to server to start 
lnd_status="$(lncli --network testnet state | jq -r .state)"
# Wait till lnd starts
while [ $lnd_status != "SERVER_ACTIVE" ]
do
  lnd_status="$(lncli --network testnet state | jq .state)"
  echo "[DEBUG] Waiting for lnd to start. Server status $lnd_status"
  sleep 5
done

while [ 1 -ne 0 ]
do
  # Do busy work / alerting / monitoring here
  sleep 1
done
