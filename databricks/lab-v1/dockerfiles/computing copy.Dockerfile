ARG SPARK_VERSION=3.5.0

FROM bitnami/spark:${SPARK_VERSION}

USER root

# Install OpenJDK 11
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    # openjdk-11-jdk \
    # openjdk-11-jre

# Set Java environment variables
# ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# ENV PATH=$PATH:$JAVA_HOME/bin

# Set Spark environment variables
# ENV SPARK_HOME=/opt/bitnami/spark
# ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-

# Create necessary directories
# RUN mkdir -p /home/jovyan/work && \
#     mkdir -p /home/jovyan/.jupyter && \
#     chmod -R 777 /home/jovyan/work

# Install MinIO and Delta Lake Jars # Download Jars (Maven Central)
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar -P /opt/bitnami/spark/jars/
RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.780/aws-java-sdk-bundle-1.12.780.jar -P /opt/bitnami/spark/jars/
RUN wget https://repo1.maven.org/maven2/io/delta/delta-spark_2.13/3.3.0/delta-spark_2.13-3.3.0.jar -P /opt/bitnami/spark/jars/

# Install Delta Lake and other dependencies
RUN pip install --no-cache-dir \
    delta-spark==3.3.0 \
    boto3 \
    s3fs

WORKDIR /opt/bitnami/spark

# Configure Spark for Delta Lake
ENV SPARK_EXTRA_CLASSPATH="/opt/bitnami/spark/jars/delta-spark_2.13-3.3.0.jar:/opt/bitnami/spark/jars/delta-spark_2.13-3.3.0.jar"
ENV SPARK_EXTRA_CLASSPATH="/opt/bitnami/spark/jars/aws-java-sdk-bundle-1.12.780.jar:/opt/bitnami/spark/jars/aws-java-sdk-bundle-1.12.780.jar"
ENV SPARK_EXTRA_CLASSPATH="/opt/bitnami/spark/jars/hadoop-aws-3.4.1.jar:/opt/bitnami/spark/jars/hadoop-aws-3.4.1.jar"

USER 1001
