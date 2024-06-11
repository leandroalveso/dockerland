FROM apache-spark-base AS apache-spark

# -- Layer: Metadata

ARG BUILD_DATE="$(date -u +'%Y-%m-%d')"
ARG SPARK_VERSION=3.5.1
ARG SPARK_MASTER_HOST=spark-master
ARG SPARK_MASTER_PORT=7077
ARG SPARK_UI_PORT=8080
ARG HADOOP_VERSION=3

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="Apache Spark"
LABEL org.label-schema.description="Apache Spark Image"

ENV SPARK_HOME /usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PYSPARK_PYTHON python3

# -- Layer: Apache Spark

RUN apt-get update && apt-get install -y curl unzip

RUN curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -o spark.tgz \
    && tar -xf spark.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /usr/bin/ \
    && mkdir /usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/logs \
    && rm spark.tgz

# -- Runtime

WORKDIR ${SPARK_HOME}

EXPOSE ${SPARK_MASTER_PORT} ${SPARK_UI_PORT}

CMD [ "bash" ]