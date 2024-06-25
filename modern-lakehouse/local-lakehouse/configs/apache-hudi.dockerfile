ARG java_image_tag="11-jre-slim"
# ARG java_image_tag="17-jre"

FROM openjdk:${java_image_tag} AS hudi-base
# FROM eclipse-temurin:${java_image_tag}

# -- Layer: Image Metadata

ARG BUILD-DATE="$(date -u +'%Y-%m-%d')"
ARG HADOOP_VERSION="3.3.6"
ARG SPARK_VERSION="3.4.3"
ARG SPARK_MAJOR_VERSION="3.4"
ARG SPARK_PACKAGE="spark-${SPARK_VERSION}-bin-hadoop3"

LABEL org.label-schema.build-date=${BUILD-DATE}
LABEL org.label-schema.description="Apache Hudi image"
LABEL org.label-schema.schema-version="1.0"

# -- Star image from base image
FROM hudi-base AS hudi

# Install required packages # remove -> // openjdk-8-jdk \
RUN apt-get update \
    && apt-get install -y wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN tar -xzf hadoop-${HADOOP_VERSION}.tar.gz
RUN rm hadoop-${HADOOP_VERSION}.tar.gz

# Download and install Spark
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz
RUN tar -xzf ${SPARK_PACKAGE}.tgz
RUN rm ${SPARK_PACKAGE}.tgz

# Set environment variables
ENV HADOOP_HOME=/hadoop-${HADOOP_VERSION} \
    SPARK_HOME=/spark-${SPARK_VERSION}-bin-hadoop3 \
    PATH=$PATH:$HADOOP_HOME/bin:$SPARK_HOME/bin \
    HUDI_CONF_BASE_PATH="/hudi" \
    HUDI_CONF_HIVE_SYNC_ENABLED="true" \
    HUDI_CONF_HIVE_METASTORE_URI="thrift://hive-metastore:9083"

# Configure Hadoop and Hive Metastore
RUN mkdir -p $HADOOP_HOME/dfs/name \
    && mkdir -p $HADOOP_HOME/dfs/data \
    && mkdir -p /hive \
    && echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_HOME/etc/hadoop/core-site.xml \
    && echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && echo "<configuration>" >> $HADOOP_HOME/etc/hadoop/core-site.xml \
    && echo "<property><name>fs.defaultFS</name><value>hdfs://namenode:9000</value></property>" >> $HADOOP_HOME/etc/hadoop/core-site.xml \
    && echo "</configuration>" >> $HADOOP_HOME/etc/hadoop/core-site.xml \
    && echo "<configuration>" >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && echo "<property><name>dfs.replication</name><value>1</value></property>" >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && echo "<property><name>dfs.namenode.name.dir</name><value>file://${HADOOP_HOME}/dfs/name</value></property>" >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && echo "<property><name>dfs.datanode.data.dir</name><value>file://${HADOOP_HOME}/dfs/data</value></property>" >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && echo "</configuration>" >> $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Expose ports
EXPOSE 9000 9083 8088 7077

# Start services

RUN spark-shell --packages org.apache.hudi:hudi-spark$SPARK_MAJOR_VERSION-bundle_2.12:0.14.1 \
    --conf 'spark.serializer=org.apache.spark.serializer.KryoSerializer' \
    --conf 'spark.sql.catalog.spark_catalog=org.apache.spark.sql.hudi.catalog.HoodieCatalog' \
    --conf 'spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension' \
    --conf 'spark.kryo.registrator=org.apache.spark.HoodieSparkKryoRegistrar'

# CMD service ssh start \
#     && $HADOOP_HOME/bin/hdfs namenode -format \
#     && $HADOOP_HOME/sbin/start-dfs.sh \
#     && $SPARK_HOME/sbin/start-master.sh \
#     && hive --service metastore & spark-submit --master spark://namenode:7077 \
#         --class org.apache.hudi.utilities.sources.helpers.IngestionCommitObserver \
#         /hudi/packaging/hudi-utilities-bundle/target/hudi-utilities-bundle_0.12.1.jar