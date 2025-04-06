ARG SPARK_VERSION=3.5.0

FROM jupyter/pyspark-notebook:spark-${SPARK_VERSION}

USER root

# Install OpenJDK 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Java Home
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Install Python dependencies
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Create directory for external JARs
RUN mkdir -p /opt/spark/jars

# Set environment variables for Delta Lake
ENV SPARK_EXTRA_CLASSPATH="/opt/spark/jars/*"

USER ${NB_UID}

# Copy spark-defaults.conf
COPY ./setup/computing/spark-defaults.conf /usr/local/spark/conf/
