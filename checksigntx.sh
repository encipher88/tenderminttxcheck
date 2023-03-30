#!/bin/bash
for((;;)); do
curl localhost:26657/consensus_state -s | grep $(curl -s localhost:26657/status | jq -r .result.validator_info.address[:12]) > $HOME/namadaout.txt
curl localhost:26657/consensus_state -s | grep $(curl -s localhost:26657/status | jq -r .result.validator_info.address[:12])
sleep 1
done
