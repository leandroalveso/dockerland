ARG BASE_IMAGE_TAG=11-jre-slim

FROM openjdk:${BASE_IMAGE_TAG} as spark-base

# -- Layer: Image Metadata

ARG shared_workspace=/opt/workspace
ARG BUILD_DATE="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="Apache Spark cluster"
LABEL org.label-schema.description="Apache Spark cluster-base image"

# -- Layer: OS + Python 3

RUN mkdir -p ${shared_workspace} \
    && apt-get update -y \
    && apt-get install -y python3 python3-pip python3-dev \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${shared_workspace}

# -- Layer: Runtime

VOLUME ${shared_workspace}

CMD ["bash"]