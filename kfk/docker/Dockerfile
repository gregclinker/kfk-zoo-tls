FROM centos:7
LABEL maintainer "boblee"  

 
# Install required system packages and dependencies
RUN yum update -y && yum install -y java-11-openjdk-11.0.13.0.8-1.el7_9 \ 
       java-11-openjdk-devel-11.0.13.0.8-1.el7_9 acl ca-certificates curl gzip libc6 netcat procps tar zlib1g net-tools wget \ 
    && echo "securerandom.source=file:/dev/urandom" >> /etc/alternatives/jre/lib/security/java.security
  
ENV SCALA_VERSION="2.13" \
    KAFKA_VERSION="3.1.1" \
    KAFKA_USER=kafka \
    KAFKA_LOG_DIR=/kafka-logs \
    KAFKA_CERTS=/certs 
    

RUN cd /opt/; \
    curl -v -o kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz; \
    tar -xzvf kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz ; \
    mv "/opt/kafka_$SCALA_VERSION-$KAFKA_VERSION" /opt/kafka ; \
    rm -rf "/opt/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"

COPY scripts/ /opt/scripts/
COPY log4j.properties /opt/kafka/config/log4j.properties

RUN groupadd -r $KAFKA_USER --gid=1000 && \
    useradd -r -g $KAFKA_USER --uid=1000 $KAFKA_USER && \
    mkdir -p "$KAFKA_LOG_DIR" "$KAFKA_CERTS" "/opt/scripts" && \
    chown -R $KAFKA_USER:$KAFKA_USER "$KAFKA_LOG_DIR" "/opt" "$KAFKA_CERTS" && \
    chmod 775 -R "$KAFKA_LOG_DIR" "/opt" "$KAFKA_CERTS" ; \
    yum clean all && rm -rf /etc/yum.repos.d/* && rm -rf /var/cache/yum
    
ENV KAFKA_HOME=/opt/kafka \
    JAVA_HOME=/etc/alternatives/jre \
    PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/bin:${PATH} \
    KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:///opt/kafka/config/log4j.properties"

WORKDIR $KAFKA_HOME
VOLUME ["$KAFKA_LOG_DIR"]

EXPOSE 9092

USER $KAFKA_USER

ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"]