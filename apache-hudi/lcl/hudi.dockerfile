FROM hudi-base

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"
ARG delta_package_version="delta-core_2.13:2.4.0"
ARG spark_xml_package_version="spark-xml_2.13:0.18.0"
ARG delta_hudi="delta-hudi_2.13:3.2.0"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Apache Hudi (with Apache Spark) base image"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: Apache Spark

ARG spark_version="3.4.1"
ARG hadoop_version="3"
ARG hudi_version="0.14.1"

RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz \
    && tar -xf spark.tgz \
    && mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ \
    && echo "alias pyspark=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/pyspark" >> ~/.bashrc \
    && echo "alias spark-shell=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/spark-shell" >> ~/.bashrc \
    && mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs \
    && rm spark.tgz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
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

# -- Apache Hudi

ARG spark_major_version="3.4"

RUN ${SPARK_HOME}/bin/spark-shell --packages org.apache.hudi:hudi-spark${spark_major_version}-bundle_2.12:${hudi_version} \
        --conf 'spark.serializer=org.apache.spark.serializer.KryoSerializer' \
        --conf 'spark.sql.catalog.spark_catalog=org.apache.spark.sql.hudi.catalog.HoodieCatalog' \
        --conf 'spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension' \
        --conf 'spark.kryo.registrator=org.apache.spark.HoodieSparkKryoRegistrar' \
    && ${SPARK_HOME}/bin/spark-shell --packages io.delta:${delta_package_version} \
        --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
        --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    && ${SPARK_HOME}/bin/spark-shell --packages com.databricks:${spark_xml_package_version} \
    && ${SPARK_HOME}/bin/spark-shell --packages org.apache.spark:spark-sql-kafka-0-10_2.13:3.5.1
    # && ${SPARK_HOME}/bin/spark-shell --packages io.delta:${delta_hudi}