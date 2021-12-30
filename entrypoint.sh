#!/bin/sh

endpoint=$(cat /app/endpoints | grep 'POST' | awk '{print $NF}')
secret=''

echo "Using endpoint: ${endpoint}"
echo "with secret: ${secret}"

while true; do
  curl -X POST -d "{\"secret\": \"${secret}\"}" ${endpoint}
  sleep 300
done
