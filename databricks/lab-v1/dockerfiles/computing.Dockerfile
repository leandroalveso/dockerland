# ./dockerfiles/computing.Dockerfile
ARG SPARK_VERSION=3.5.0
FROM bitnami/spark:${SPARK_VERSION}

USER root

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download required JARs
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar -P /opt/bitnami/spark/jars/ && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.780/aws-java-sdk-bundle-1.12.780.jar -P /opt/bitnami/spark/jars/ && \
    wget https://repo1.maven.org/maven2/io/delta/delta-spark_2.13/3.3.0/delta-spark_2.13-3.3.0.jar -P /opt/bitnami/spark/jars/ && \
    wget https://repo1.maven.org/maven2/io/delta/delta-storage/3.3.0/delta-storage-3.3.0.jar -P /opt/bitnami/spark/jars/

# Install Python dependencies
RUN pip install --no-cache-dir \
    delta-spark==3.3.0 \
    boto3 \
    s3fs

WORKDIR /opt/bitnami/spark

# Set proper permissions
RUN chown -R 1001:1001 /opt/bitnami/spark/jars/

USER 1001
