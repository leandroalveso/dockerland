# Use a base image with Java installed
FROM openjdk:11-jre-slim

# Define the NiFi version
ENV NIFI_VERSION=1.17.0

# Set the NiFi home directory
ENV NIFI_HOME=/opt/nifi/nifi-${NIFI_VERSION}

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Download and install Apache NiFi
RUN wget https://archive.apache.org/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.zip -O /tmp/nifi-bin.zip \
    && unzip /tmp/nifi-bin.zip -d /opt/nifi \
    && rm /tmp/nifi-bin.zip \
    && mv /opt/nifi/nifi-${NIFI_VERSION} ${NIFI_HOME}

# Copy the custom configuration files (this step assumes you have a conf directory in the same location as the Dockerfile)
COPY conf ${NIFI_HOME}/conf

# Set the working directory
WORKDIR ${NIFI_HOME}

# Expose NiFi ports
EXPOSE 8080 8443 8082

# Set the NiFi node properties for clustering (these can be overridden at runtime)
ENV NIFI_CLUSTER_IS_NODE=true
ENV NIFI_CLUSTER_NODE_PROTOCOL_PORT=8082
ENV NIFI_ZK_CONNECT_STRING=zookeeper:2181

# Add NiFi binaries to PATH
ENV PATH=$PATH:${NIFI_HOME}/bin

# Define the entrypoint
ENTRYPOINT ["nifi.sh", "run"]