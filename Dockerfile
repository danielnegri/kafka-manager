FROM openjdk:8
MAINTAINER danielgomesnegri@gmail.com

ARG SBT_VERSION=1.2.8
ARG RELEASE_VERSION=2.0.0.2

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV RELEASE_URL=https://github.com/yahoo/kafka-manager/archive/$RELEASE_VERSION.tar.gz
ENV ZK_HOST=localhost:2181
ENV KAFKA_MANAGER_CONFIG="conf/application.conf"
ENV KAFKA_MANAGER_PATH=/usr/share/kafka-manager
ENV SOURCE_PATH=/usr/src

RUN mkdir -p ${SOURCE_PATH}
WORKDIR ${SOURCE_PATH}

RUN set -x \
    && apt-get update \
    && apt-get install -y curl tar unzip \
    && : "------------- SBT -------------" \
    && curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb \
    && dpkg -i sbt-$SBT_VERSION.deb \
    && : "------------- Kafka Manager -------------" \
    && curl -SL $RELEASE_URL -o kafka-manager.tar.gz \
    && tar -zxvf kafka-manager.tar.gz \
    && cd kafka-manager-$RELEASE_VERSION \
    && sbt clean dist \
    && unzip  -d /tmp ./target/universal/kafka-manager-${RELEASE_VERSION}.zip \
    && cd /tmp \
    && mv /tmp/kafka-manager-${RELEASE_VERSION} $KAFKA_MANAGER_PATH \
    && rm -rf $SOURCE_PATH /tmp/kafka-manager-${RELEASE_VERSION}.zip \
    && : "---------- Remove build deps ----------" \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND newt

ADD entrypoint.sh ${KAFKA_MANAGER_PATH}/
ADD application.conf ${KAFKA_MANAGER_PATH}/conf/
ADD logback.xml ${KAFKA_MANAGER_PATH}/conf/
WORKDIR ${KAFKA_MANAGER_PATH}
EXPOSE 9000

CMD ["./entrypoint.sh"]
