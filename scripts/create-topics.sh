#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP="${BOOTSTRAP:-localhost:19092}"
CONTAINER="${CONTAINER:-kafka}"

docker compose exec -T "$CONTAINER" /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server "$BOOTSTRAP" \
  --create --if-not-exists \
  --topic orders \
  --partitions 3 \
  --replication-factor 1

echo "topic 'orders' ready (3 partitions, RF=1)"
