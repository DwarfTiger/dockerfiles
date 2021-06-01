ARG BASE_IMG=arm64v8/openjdk:8-jre
FROM $BASE_IMG

ARG BUILD_DATE
ARG VCS_REF

LABEL io.fogsy.build-date=$BUILD_DATE \
      io.fogsy.license="Apache 2.0" \
      io.fogsy.organization="fogsy-io" \
      io.fogsy.url="https://fogsy.io/" \
      io.fogsy.vcs-ref=$VCS_REF \
      io.fogsy.vcs-type="Git" \
      io.fogsy.vcs-url="https://github.com/fogsy-io/dockerfiles"

ENV KAFKA_VERSION=2.2.0 \
    SCALA_VERSION=2.12 \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=2.29-r0

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY qemu-aarch64-static /usr/bin

COPY fs ./

RUN chmod a+x /tmp/*.sh 
RUN mv /tmp/start-kafka.sh /tmp/broker-list.sh /tmp/create-topics.sh /tmp/versions.sh /usr/bin 
RUN sync
RUN tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
 && rm -rf /tmp/* 

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
