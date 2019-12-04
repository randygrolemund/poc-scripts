# XHD Lucky block analyzer. Created by BearlyHealz.

# Blockchain Explorer URL
blockExplorer_url="https://explorer.xrphd.org/explorer/api/blockchain/block"

# Get last 20 blocks worth of data
get_blockHash=$(curl $blockExplorer_url?count=20 -s -k -X GET –header Content-Type: application/json’ | jq '.data[].hash' | tr -d '"')
hash_array=($get_blockHash)

# Set Variables
counter=0

# Loop through payments
for i in "${hash_array[@]}"
do

        lastPayments=$(curl $blockExplorer_url/$i/transaction  -s -k -X GET –header Content-Type: application/json | jq '.data[0].vout[0].amount' | tr -d '"')
        lastPayment_array=($lastPayments)

        # Check last payment is lucky, if so, break loop.
        if [[ ${lastPayment_array%.*} > '1500.10000000' ]]
        then
            break

        else
            # Increment counter if block was not a lucky block
            counter=$((counter+1))

        fi
done

if [[ $counter > '0' ]]
then
    # Get most recent block payment
    last_paymentHash=${hash_array[0]}
    lastPayment=$(curl $blockExplorer_url/$last_paymentHash/transaction  -s -k -X GET –header Content-Type: application/json | jq '.data[0].vout[0].amount' | tr -d '"')

    # Calculate the next payment
    next_payment=$((150000+(148500*counter)))

    echo "The next block IS a lucky block, and the payment will be: $next_payment XHD. The last payment was $lastPayment XHD"
else
    echo "Next block is NOT a lucky block, last payment was $lastPayment_array XHD"
fi