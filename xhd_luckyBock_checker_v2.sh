#!/bin/bash

# XHD Lucky block analyzer. Created by BearlyHealz. https://github.com/randygrolemund/poc-scripts
# You must have jq installed. If Ubuntu: apt install -y jq

# Blockchain Explorer URL
blockExplorer_url='https://explorer.xrphd.org/explorer/api/blockchain'

# Get data from explorer API
get_blockExplorer=$(curl $blockExplorer_url/network -s -k -X GET –header Content-Type: application/json’)

# Parse accumulatesubsidy (overage)
get_accumulateSubsidy=$(jq '.accumulatesubsidy' <<< $get_blockExplorer | tr -d '"' )

# Parse last block hash
get_lastBlockHash=$(jq '.best.hash' <<< $get_blockExplorer | tr -d '"' )

# Get last payment from API
lastPayment=$(curl $blockExplorer_url/block/$get_lastBlockHash/transaction  -s -k -X GET –header Content-Type: application/json | jq '.data[0].vout[0].amount' | tr -d '"')

# Remove decimal
get_accumulateSubsidy=${get_accumulateSubsidy%.*}

# Check if next payment will be lucky
if [[ $get_accumulateSubsidy > '1' ]]
    then
            # Calculate the next reward
            estimatedReward=$((get_accumulateSubsidy+150000))
            echo "Next block IS a lucky block! The estimated next reward should be $estimatedReward XHD. Last reward: $lastPayment XHD."

    else
            echo "Next block IS NOT a lucky block! Last reward: $lastPayment XHD."

 fi



