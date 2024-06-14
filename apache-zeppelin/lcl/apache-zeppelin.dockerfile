FROM cluster-base:latest AS BASE

ENV ZEPPELIN_VERSION 0.11.1

RUN apt-get -y update && apt-get -y install curl
RUN curl -fSL "https://downloads.apache.org/zeppelin/zeppelin-$ZEPPELIN_VERSION/zeppelin-$ZEPPELIN_VERSION.tgz" -o /tmp/zeppelin.tgz \
    && tar -xzvf /tmp/zeppelin.tgz -C /opt/ \
    && mv /opt/zeppelin-* /opt/zeppelin \
    && rm /tmp/zeppelin.tgz

WORKDIR /opt/zeppelin

CMD ["/opt/zeppelin/bin/zeppelin.sh"]