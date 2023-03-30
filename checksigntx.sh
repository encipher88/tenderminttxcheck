#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install original-awk -y
sudo apt install bc -y
for((;;)); do

# Execute the command and store the output in a variable
consensus=$(curl -s localhost:26657/consensus_state)
status=$(curl -s localhost:26657/status)

result=$((echo $consensus | jq '.result.round_state.height_vote_set[0].prevotes_bit_array') | awk -F'=' '{print $2}')
result=${result%\"}

# Compare the result with zero

if (( $(echo "$result == 0.00" | bc -l) )); then
# If the result is equal to zero, execute the following command
continue  
else
# If the result is not equal to zero, execute the following command
clear
echo "PROPOSER"
echo $consensus | jq -r '.result.round_state.proposer' | sed 's/[{}]//g'
echo "--------------------------------------------------------------------"
echo "Consensus"
echo $result
echo "--------------------------------------------------------------------"
output=$(echo $consensus | jq '.result.round_state.height_vote_set[0].prevotes[]')
echo "$output" | pr -3 -t -w 120
echo "--------------------------------------------------------------------"

address1=$(echo $consensus | jq -r '.result.round_state.proposer.address')
address2=$(echo $status | jq -r '.result.validator_info.address')
address3=$(echo $status | jq -r '.result.validator_info.address[:12]')
input=$(echo $consensus | jq '.result.round_state.height_vote_set[0].prevotes[]' | grep "$address3")
output1=${input#*:}   # Remove everything before the colon
output2=${output1%% *}  # Remove everything after the first space
# echo "--------------------------------------------------------------------"
#echo -e $address1
# echo "--------------------------------------------------------------------"
#echo -e $address2
# echo "--------------------------------------------------------------------"
#echo -e $address3
# echo "--------------------------------------------------------------------"
#echo $output | pr -1 -t
 #echo "--------------------------------------------------------------------"
echo -e $input
 echo "--------------------------------------------------------------------"
#echo -e $output1
 #echo "--------------------------------------------------------------------"
#echo -e $output2
# echo "--------------------------------------------------------------------"

if [ "$address1" != "$address2" ]; then
  echo -e "\033[31m YOU ARE NOT PROPOSER \033[0m"
  echo "--------------------------------------------------------------------"
  if [ "$address3" == "$output2" ]; then
  echo -e "\033[32m YOU ARE A SIGNER \033[0m"
  else
   echo -e "\033[31m YOU ARE NOT A SIGNER \033[0m"
  fi
else
  echo -e "\033[32m YOU ARE PROPOSER \033[0m"
fi


fi
sleep 0.2
done
