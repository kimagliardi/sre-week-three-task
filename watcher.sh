#!/bin/bash

export NAMESPACE="sre"
export DEPLOYMENT="swype-app"
export MAX_RESTARTS=3

# Start a Loop
while true; do
    # Check Pod Restarts
    RESTARTS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}')

    # Display Restart Count
    echo "Swype-app restart count: $RESTARTS"

    # Check Restart Limit
    if [ $RESTARTS -gt $MAX_RESTARTS ]; then
        # Scale Down if Necessary
        echo "Scaling down deployment $DEPLOYMENT in namespace $NAMESPACE"
        kubectl scale --replicas=0 deployment/$DEPLOYMENT -n $NAMESPACE
        break
    fi

    # Pause
    sleep 60
done