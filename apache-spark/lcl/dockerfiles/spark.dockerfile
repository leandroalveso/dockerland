FROM spark-base AS spark

# -- Layer: Metadata

ARG BUILD_DATE="$(date -u +'%Y-%m-%d')"
ARG SPARK_VERSION="3.4.3"
ARG SPARK_MASTER_HOST="spark-master"
ARG SPARK_MASTER_PORT=7077
ARG HADOOP_VERSION="3"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="Apache Spark"
LABEL org.label-schema.description="Apache Spark image"

ENV SPARK_HOME /usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PYSPARK_PYTHON python3

# -- Layer: Apache Spark

RUN apt-get update && apt-get install -y curl unzip

RUN curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -o spark.tgz
RUN tar -xf spark.tgz
RUN mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /usr/bin/
RUN mkdir /usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/logs
RUN rm spark.tgz

# -- Runtime

WORKDIR ${SPARK_HOME}