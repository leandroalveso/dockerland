FROM databricks-base:latest AS databricks

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"
ARG delta_package_version="delta-core_2.13:2.4.0"
ARG spark_xml_package_version="spark-xml_2.13:0.18.0"
ARG spark_version="3.4.3"
ARG hadoop_version="3"
ARG SPARK_MASTER_HOST="databricks-master"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Databricks base image"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: Apache Spark

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST databricks-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz
RUN tar -xf spark.tgz
RUN mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/
RUN mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs
RUN rm spark.tgz

RUN echo "alias pyspark=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/pyspark" >> ~/.bashrc
RUN echo "alias spark-shell=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/spark-shell" >> ~/.bashrc

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

RUN ${SPARK_HOME}/bin/spark-shell --packages io.delta:${delta_package_version} \
    --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    && ${SPARK_HOME}/bin/spark-shell --packages com.databricks:${spark_xml_package_version} \
    && ${SPARK_HOME}/bin/spark-shell --packages org.apache.spark:spark-sql-kafka-0-10_2.13:3.4.3