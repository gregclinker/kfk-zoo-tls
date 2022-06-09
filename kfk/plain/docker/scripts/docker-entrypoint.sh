#!/bin/bash
set -e

if [[ -z $ZOO_CONNECT ]]; then
    echo "ZOO_CONNECT is unset or set to the empty string"
    exit
fi

if [[ $KAFKA_K8S == 'true' ]]; then
    # export KAFKA_BROKER_ID=$((${HOSTNAME##*-}+1))
    export KAFKA_DOMAIN=.$(hostname -d)
    # KAFKA_PORT=$(($KAFKA_PORT + $KAFKA_BROKER_ID))
fi

CONFIG="/opt/kafka/config/server.properties"
    {
        echo "broker.id=${KAFKA_BROKER_ID:-1}"
        echo "listeners=INTERNAL://0.0.0.0:9092,EXTERNAL://0.0.0.0:${KAFKA_PORT}"
        # echo "advertised.listeners=INTERNAL://$HOSTNAME${KAFKA_DOMAIN:-}:9092,EXTERNAL://$ADVERTISED_LISTENER"
        echo "advertised.listeners=EXTERNAL://$ADVERTISED_LISTENER"
        echo "listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT"
        echo "inter.broker.listener.name=EXTERNAL"
        echo "log.dirs=$KAFKA_LOG_DIR"
    
        echo "num.partitions=${KAFKA_NUM_PARTITIONS:-3}"
        echo "default.replication.factor=${KAFKA_TOPIC_REPLICATION_FACTOR:-3}"
        echo "auto.create.topics.enable=false"
        echo "min.insync.replicas=${KAFKA_MIN_INSYNC:-1}"

        echo "log.retention.hours=${KAFKA_LOG_RETENTION_HOURS:-48}"
        echo "log.cleaner.min.compaction.lag.ms=${KAFKA_CLEANER_MIN_COMPACT_LAG:-7200000}"
        echo "log.cleaner.delete.retention.ms${KAFKA_CLEANER_DELETE_RETENTION:-7200000}"

        echo "zookeeper.connect=$ZOO_CONNECT"
        echo "zookeeper.connection.timeout.ms=${ZOO_CONNECTION_TIMEOUT_MS:-60000}"
    } > "$CONFIG"

LOG4J_CONFIG="/opt/kafka/config/log4j.properties"
    {
        echo "log4j.rootLogger=INFO, stdout"

        echo "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
        echo "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout"
        echo "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"


        echo "log4j.logger.kafka.authorizer.logger=WARN"
        echo "log4j.logger.kafka.log.LogCleaner=INFO"
        echo "log4j.logger.kafka.producer.async.DefaultEventHandler=DEBUG"
        echo "log4j.logger.kafka.controller=TRACE"
        echo "log4j.logger.kafka.network.RequestChannel$=WARN"
        echo "log4j.logger.kafka.request.logger=WARN"
        echo "log4j.logger.state.change.logger=TRACE"
        echo "log4j.logger.kafka=INFO"
    } > $LOG4J_CONFIG

export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:///opt/kafka/config/log4j.properties"
rm -rf $KAFKA_LOG_DIR/lost+found
exec "$@"
