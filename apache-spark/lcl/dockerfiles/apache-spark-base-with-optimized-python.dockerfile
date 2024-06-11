ARG BASE_IMAGE_TAG=11-jre-slim 

FROM openjdk:${BASE_IMAGE_TAG} as apache-spark-base

# -- Layer: Image Metadata

ARG SHARED_WORKSPACE=/opt/workspace

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"
ENV SHARED_WORKSPACE=${SHARED_WORKSPACE}
ENV PYTHON_VERSION=3.11.9
ENV PYTHON_MAJOR_VERSION=3.11

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="Apache Spark Cluster with Python"
LABEL org.label-schema.description="Apache Spark Cluster-Base Image with Python"

# -- Layer: OS + Python 3

RUN apt-get -y update \
    && apt-get -y install build-essential openssl make gcc wget \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
    python3-pip python3-dev \
    && apt-get -y autoremove -yqq --purge \
    && apt-get -y clean \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# download-extract-remove-Python-pkg
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -xf "Python-$PYTHON_VERSION.tgz" \
    && rm -rf "Python-$PYTHON_VERSION.tgz"

ENV FILES_PATH="Python-$PYTHON_VERSION"

# move directory
WORKDIR "$FILES_PATH"

# configure the build with optimization flags
RUN ./configure --enable-optimizations

# build Python using multiple processors to speed up
RUN make -j$(nproc)
# RUN make && make install

# install Python on system
RUN make altinstall

# add alias-command to run python
RUN export PYTHON_MAJOR_VERSION="$PYTHON_MAJOR_VERSION"
RUN echo 'alias python=/usr/local/bin/python$PYTHON_MAJOR_VERSION' >> ~/.bashrc

RUN pip install --upgrade --break-system-packages pip
RUN pip install --no-cache-dir --break-system-packages wheel pyspark==3.5.1

WORKDIR /

# -- Layer: Runtime

VOLUME ${SHARED_WORKSPACE}

CMD ["bash"]