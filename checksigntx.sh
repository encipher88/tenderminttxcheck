#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install bc awk -y
for((;;)); do

# Execute the command and store the output in a variable
result=$((curl -s localhost:26657/consensus_state | jq '.result.round_state.height_vote_set[0].prevotes_bit_array') | awk -F'=' '{print $2}')
result=${result%\"}

# Compare the result with zero
if (( $(echo "$result == 0.00" | bc -l) )); then
  # If the result is equal to zero, execute the following command
continue  
else
  # If the result is not equal to zero, execute the following command
clear



echo "PROPOSER"
curl -s localhost:26657/consensus_state | jq '.result.round_state.proposer'
echo "--------------------------------------------------------------------"
echo $result
echo "--------------------------------------------------------------------"
output=$(curl -s localhost:26657/consensus_state | jq '.result.round_state.height_vote_set[0].prevotes[]')
echo "$output" | pr -3 -t -w 120
echo "--------------------------------------------------------------------"

address1=$(curl -s localhost:26657/consensus_state | jq -r '.result.round_state.proposer.address')
address2=$(curl -s localhost:26657/status | jq -r .result.validator_info.address)
address3=$(curl -s localhost:26657/status | jq -r .result.validator_info.address[:12])
input=$(curl localhost:26657/consensus_state -s | grep $(curl -s localhost:26657/status | jq -r .result.validator_info.address[:12]))
output=${input#*:}   # Remove everything before the colon
output=${output%% *}  # Remove everything after the first space
 


if [ "$address1" != "$address2" ]; then
  echo -e "\033[31m YOU ARE NOT PROPOSER \033[0m"
  echo "--------------------------------------------------------------------"
  if [ "$address3" == "$output" ]; then
  echo -e "\033[32m YOU ARE A SIGNER \033[0m"
  else
   echo -e "\033[31m YOU ARE NOT A SIGNER \033[0m"
  fi
else
  echo -e "\033[32m YOU ARE PROPOSER \033[0m"
fi


fi
sleep 0.5
done
