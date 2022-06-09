#!/bin/bash
set -e

true > /opt/kafka/config/producer.properties

PRODUCER_CONFIG="/opt/kafka/config/producer.properties"
    {
        echo "bootstrap.servers=$KAFKA_CFG_BOOTSTRAP_SERVERS"
        echo "security.protocol=${KAFKA_CFG_PRODUCER_SECURITY_PROTOCOL:-SSL}"
        echo "ssl.protocol=${KAFKA_CFG_PRODUCER_SSL_PROTOCOL:-TLSv1.2}"
        echo "ssl.truststore.location=$KAFKA_CFG_PRODUCER_TRUST_STORE_PATH"
        echo "ssl.truststore.password=$KAFKA_CFG_PRODUCER_TRUST_STORE_PASSWORD"       
        echo "ssl.keystore.location=$KAFKA_CFG_PRODUCER_KEY_STORE_PATH"
        echo "ssl.keystore.password=$KAFKA_CFG_PRODUCER_KEY_STORE_PASSWORD"
        echo "ssl.key.password=$KAFKA_CFG_CA_KEY_PASSWORD"
    } > "$PRODUCER_CONFIG"

exec "$@"
