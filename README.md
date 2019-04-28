# Kafka Manager (Docker)

This is a Docker image for [Kafka Manager](https://github.com/yahoo/kafka-manager) a tool for managing Apache Kafka. It supports the following:

- Manage multiple clusters
- Easy inspection of cluster state (topics, consumers, offsets, brokers, replica distribution, - partition distribution)
- Run preferred replica election
- Generate partition assignments with option to select brokers to use
- Run reassignment of partition (based on generated assignments)
- Create a topic with optional topic configs (0.8.1.1 has different configs than 0.8.2+)
- Delete topic (only supported on 0.8.2+ and remember set delete.topic.enable=true in broker config)
- Topic list now indicates topics marked for deletion (only supported on 0.8.2+)
- Batch generate partition assignments for multiple topics with option to select brokers to use
- Batch run reassignment of partition for multiple topics
- Add partitions to existing topic
- Update config for existing topic
- Optionally enable JMX polling for broker level and topic level metrics.
- Optionally filter out consumers that do not have ids/ owners/ & offsets/ directories in zookeeper.

## Usage

```
$ export ZK_HOSTS=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181
$ docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="$ZK_HOSTS" danielnegri/kafka-manager
```

## Environment Variables

The Kafka Manager image uses several environment variables which are easy to miss. While none of the variables are required, they may significantly aid you in using the image.

- APPLICATION_SECRET="${APPLICATION_SECRET:-$(date +%s | sha256sum | base64 | head -c 64 ; echo)}"
- HTTP_CONTEXT="${HTTP_CONTEXT:-/}"
- ZK_HOSTS="${ZK_HOSTS:-zookeeper:2181}"
- BASE_ZK_PATH="${BASE_ZK_PATH:-/kafka-manager}"
- KAFKA_MANAGER_LOGLEVEL="${KAFKA_MANAGER_LOGLEVEL:-INFO}"
- LOGGER_STARTUP_TIMEOUT="${LOGGER_STARTUP_TIMEOUT:-60s}"
- KAFKA_MANAGER_CONFIG="${KAFKA_MANAGER_CONFIG:-./conf/application.conf}"
- HTTP_PORT="${HTTP_PORT:-9000}"
