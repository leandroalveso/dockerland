FROM openjdk:8-jre-alpine

WORKDIR /opt
ENV HADOOP_VERSION=3.3.4
ENV METASTORE_VERSION=3.0.0
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN apk update && apk add bash
RUN apk --no-cache add curl

RUN curl -L <https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz> | tar zxf - && \\
    curl -L <https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz> | tar zxf -
RUN curl -L -o postgresql-42.6.0.jar <https://jdbc.postgresql.org/download/postgresql-42.6.0.jar> && \\
    cp postgresql-42.6.0.jar ${HIVE_HOME}/lib/ && \\
    rm -rf  postgresql-42.6.0.jar

COPY metastore-site.xml ${HIVE_HOME}/conf
COPY entrypoint.sh /entrypoint.sh
RUN addgroup -S hive -g 1000 && \\
    adduser -S -G hive -u 1000 -h ${HIVE_HOME} hive && \\
    chown hive:hive -R ${HIVE_HOME} && \\
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]