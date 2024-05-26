ARG debian_buster_image_tag=11-jre-slim

FROM openjdk:${debian_buster_image_tag} AS spark-base

# -- Layer: OS + Python 3.11

ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace} \
    && apt-get update -y \
    && apt-get install -y python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${shared_workspace}

# -- Runtime

VOLUME ${shared_workspace}
CMD ["bash"]

FROM spark-base

# -- Layer: Apache Spark

ARG spark_version="3.4.0"
ARG hadoop_version="3"

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

RUN apt-get update && apt-get install -y curl

RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz
RUN tar -xf spark.tgz
RUN mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/
RUN mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs
RUN rm spark.tgz

# -- Runtime

WORKDIR ${SPARK_HOME}