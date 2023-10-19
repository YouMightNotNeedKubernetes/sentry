#!/bin/bash

# NOTE: This step relies on `kafka` being available from the previous `snuba-api bootstrap` step
# XXX(BYK): We cannot use auto.create.topics as Confluence and Apache hates it now (and makes it very hard to enable)
EXISTING_KAFKA_TOPICS=$(kafka-topics --list --bootstrap-server kafka:9092 2>/dev/null)
NEEDED_KAFKA_TOPICS="ingest-attachments ingest-transactions ingest-events ingest-replay-recordings profiles ingest-occurrences ingest-metrics ingest-performance-metrics"
for topic in $NEEDED_KAFKA_TOPICS; do
  if ! echo "$EXISTING_KAFKA_TOPICS" | grep -qE "(^| )$topic( |$)"; then
    kafka-topics --create --topic $topic --bootstrap-server kafka:9092
    echo ""
  fi
done
