FROM databricks-base:latest AS databricks

# -- Layer: Image Metadata

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.description="Databricks image"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: Apache Spark

ENV DELTA_CORE_PACKAGE_VERSION="delta-core_2.13:2.4.0"
ENV SPARK_XML_PACKAGE_VERSION="spark-xml_2.13:0.18.0"
ENV SPARK_SQL_KAFKA_PACKAGE_VERSION="spark-sql-kafka-0-10_2.13:3.4.3"
ENV SPARK_VERSION="3.4.3"
ENV HADOOP_VERSION="3"

ENV SPARK_HOME="/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
ENV SPARK_MASTER_HOST="databricks-master"
ENV SPARK_MASTER_PORT="7077"
ENV PYSPARK_PYTHON="python3"

RUN curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -o spark.tgz
RUN tar -xf spark.tgz
RUN mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /usr/bin/
RUN mkdir /usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/logs
RUN rm spark.tgz

RUN echo "alias pyspark=/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/pyspark" >> ~/.bashrc
RUN echo "alias spark-shell=/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/spark-shell" >> ~/.bashrc

# -- Runtime

WORKDIR ${SPARK_HOME}

USER root

ARG NBuser=NBuser
ARG GROUP=NBuser

RUN groupadd -r ${GROUP} && useradd -r -m -g ${GROUP} ${NBuser}

RUN chown -R "${NBuser}":"${GROUP}" /home/"${NBuser}"/ \
    && chown -R "${NBuser}":"${GROUP}" "${SPARK_HOME}"\
    && chown -R "${NBuser}":"${GROUP}" "${SHARED_WORKSPACE}"

USER ${NBuser}

# -- Start Databricks

RUN ${SPARK_HOME}/bin/spark-shell --packages io.delta:${DELTA_CORE_PACKAGE_VERSION} \
    --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    && ${SPARK_HOME}/bin/spark-shell --packages com.databricks:${SPARK_XML_PACKAGE_VERSION} \
    && ${SPARK_HOME}/bin/spark-shell --packages org.apache.spark:${SPARK_SQL_KAFKA_PACKAGE_VERSION}