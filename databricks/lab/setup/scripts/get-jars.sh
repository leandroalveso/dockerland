#!/bin/bash
mkdir -p ./.local-env/jars
cd ./.local-env/jars

# Delta Lake
wget https://repo1.maven.org/maven2/io/delta/delta-core_2.13/2.4.0/delta-core_2.13-2.4.0.jar ./.local-env/jars
wget https://repo1.maven.org/maven2/io/delta/delta-storage/3.3.0/delta-storage-3.3.0.jar ./.local-env/jars

# Apache Iceberg
wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.13/1.8.0/iceberg-spark-runtime-3.5_2.13-1.8.0.jar ./.local-env/jars

# AWS/S3 
wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar ./.local-env/jars
wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.261/aws-java-sdk-bundle-1.12.261.jar ./.local-env/jars
