ARG BASE_IMAGE_TAG=11-jre-slim

FROM openjdk:${BASE_IMAGE_TAG} as apache-spark-base

# -- Layer: Image Metadata

ARG SHARED_WORKSPACE=/opt/workspace

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"
ENV SHARED_WORKSPACE=${SHARED_WORKSPACE}
ENV PYTHON_VERSION=3.9
ENV PYTHON_MAJOR_VERSION=3.9

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="Apache Spark cluster"
LABEL org.label-schema.description="Apache Spark Cluster Base-Image"

# -- Layer: OS + Python 3

RUN mkdir -p ${SHARED_WORKSPACE} \
    && apt-get update -y \
    && apt-get install -y python3 python3-pip python3-dev \
    && apt-get -y autoremove -yqq --purge \
    && apt-get -y clean \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# -- Layer: Runtime

VOLUME ${SHARED_WORKSPACE}

CMD ["bash"]