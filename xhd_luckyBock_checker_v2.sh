#!/bin/bash

# XHD Lucky block analyzer. Created by BearlyHealz.

# Blockchain Explorer URL
blockExplorer_url='https://explorer.xrphd.org/explorer/api/blockchain/network'

# Parse accumulatesubsidy (overage)
get_accumulateSubsidy=$(curl $blockExplorer_url -s -k -X GET –header Content-Type: application/json’ | jq '.accumulatesubsidy' | tr -d '"' | bc)

# Remove decimal
get_accumulateSubsidy=${get_accumulateSubsidy%.*}

        # Check if next payment will be lucky
        if [[ $get_accumulateSubsidy > '1' ]]
        then
            # Calculate the next reward
            estimatedReward=$((get_accumulateSubsidy+150000))
            echo "Next block IS a lucky block! The estimated next reward should be $estimatedReward XHD."

        else
            echo "Next block IS NOT a lucky block!"

        fi


