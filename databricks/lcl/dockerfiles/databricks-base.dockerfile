ARG JAVA_IMAGE_TAG=21-jre

FROM eclipse-temurin:${JAVA_IMAGE_TAG} AS databricks-base

# -- Layer: Image Metadata

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.description="Databricks-cluster base image"
LABEL org.label-schema.schema-version="1.0"

# -- Layer: OS + Python + Scala

ENV DELTA_SPARK_VERSION="3.2.0"
ENV DELTALAKE_VERSION="0.17.4"

ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace} \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends curl python3 r-base netcat \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential manpages-dev python3-pip python3-dev \
    && pip3 install  --no-cache-dir --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# We are explicitly pinning the versions of various libraries which this Docker image runs on.
RUN pip3 install --quiet --no-cache-dir \
    delta-spark==${DELTA_SPARK_VERSION} deltalake==${DELTALAKE_VERSION}

ENV SCALA_HOME="/usr/bin/scala"
ENV PATH=${PATH}:${SCALA_HOME}/bin
ENV SHARED_WORKSPACE=${shared_workspace}

# -- Runtime

VOLUME ${shared_workspace}

CMD ["bash"]