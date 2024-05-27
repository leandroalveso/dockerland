FROM databricks-base

# -- Layer: Image Metadata

ARG BUILD_DATE
ARG delta_package_version
ARG spark_xml_package_version

ENV BUILD_DTA="$(date -u +'%Y-%m-%d')"
ENV delta_package_version="delta-core_2.12:2.4.0"
ENV spark_xml_package_version="spark-xml_2.12:0.18.0"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.description="Spark base image"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: Apache Spark
ARG spark_version
ARG spark_version_major

ENV spark_version="3.4.1"
ENV spark_version_major="3.4"
ENV HADOOP_VERSION="3"

RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${HADOOP_VERSION}.tgz -o spark.tgz \
    && tar -xf spark.tgz \
    && mv spark-${spark_version}-bin-hadoop${HADOOP_VERSION} /usr/bin/ \
    && echo "alias pyspark=/usr/bin/spark-${spark_version}-bin-hadoop${HADOOP_VERSION}/bin/pyspark" >> ~/.bashrc \
    && echo "alias spark-shell=/usr/bin/spark-${spark_version}-bin-hadoop${HADOOP_VERSION}/bin/spark-shell" >> ~/.bashrc \
    && mkdir /usr/bin/spark-${spark_version}-bin-hadoop${HADOOP_VERSION}/logs \
    && rm spark.tgz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${HADOOP_VERSION}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

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

RUN ${SPARK_HOME}/bin/spark-shell --packages io.delta:${delta_package_version} \
    --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    && ${SPARK_HOME}/bin/spark-shell --packages com.databricks:${spark_xml_package_version} \
    && ${SPARK_HOME}/bin/spark-shell --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1