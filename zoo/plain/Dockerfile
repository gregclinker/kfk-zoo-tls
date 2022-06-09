FROM centos:7
 
ARG ZOOKEEPER_VERSION=3.6.3
ARG DISTRO_NAME="zookeeper-${ZOOKEEPER_VERSION}"
ARG ZOO_BIN="apache-$DISTRO_NAME-bin.tar.gz"

 
ENV ZOOCFGDIR=/conf \
    ZOO_DATADIR=/data \
    ZOO_LOG_DIR=/data-log \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60 \
    ZK_SERVER_HEAP=1024 \
    PATH=$PATH:/zookeeper/bin

RUN set -eux && \
    yum update -y && yum install -y java-11-openjdk-11.0.13.0.8-1.el7_9 \
    java-11-openjdk-devel-11.0.13.0.8-1.el7_9 acl openssl ca-certificates gzip gnupg libc6 netcat nc procps tar zlib1g net-tools wget \
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/jre/lib/security/java.security ; \
    groupadd -r zookeeper --gid=1000 && \
    useradd -r -g zookeeper --uid=1000 zookeeper && \
    mkdir -p "$ZOO_DATADIR" "$ZOO_LOG_DIR" "$ZOOCFGDIR" && \
    chown zookeeper:zookeeper "$ZOO_DATADIR" "$ZOO_LOG_DIR" "$ZOOCFGDIR"

RUN set -eux && \
    wget https://downloads.apache.org/zookeeper/$DISTRO_NAME/$ZOO_BIN \
    && tar -xzvf $ZOO_BIN \
    && mv "apache-$DISTRO_NAME-bin" zookeeper \
    && rm -rf "$ZOO_BIN" \
    chown -R zookeeper:zookeeper "/$DISTRO_NAME"

WORKDIR /zookeeper

VOLUME ["$ZOO_DATADIR", "$ZOO_LOG_DIR"]
 
EXPOSE 2181 2888 3888 8080
 
USER zookeeper
COPY --chown=zookeeper:zookeeper docker-entrypoint.sh /
COPY --chown=zookeeper:zookeeper readiness.sh /

RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /readiness.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["./bin/zkServer.sh", "start-foreground"]    