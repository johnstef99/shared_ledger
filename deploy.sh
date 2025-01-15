#!/bin/sh

docker context use mambo

docker build -t shared-ledger .

IMAGE_HASH=$(docker inspect --format="{{.ID}}" shared-ledger:latest | cut -d ":" -f2)

docker tag shared-ledger:latest shared-ledger:$IMAGE_HASH

export IMAGE_HASH

echo "Image hash: $IMAGE_HASH"

docker stack deploy -c compose.yaml shared-ledger

docker context use default
