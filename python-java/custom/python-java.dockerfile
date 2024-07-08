ARG PYTHON_VERSION

FROM eclipse-temurin:21-jre AS JAVA

## -- Metadata Layer

ARG SHARED=/opt/workspace

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"
ENV PYTHON_VERSION="3.11.8"
ENV PYTHON_MAJOR_VERSION="3.11"
# $(echo $PYTHON_VERSION | cut -d'.' -f1,2)

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Custom Python-Java Runtime"
LABEL org.label-schema.description="Custom Python-Java Runtime Base Image"

# Extract the major and minor version using cut and update the environment variable
# RUN PYTHON_MAJOR_VERSION="$(echo "$PYTHON_VERSION" | cut -d '.' -f1,2)" && \
#     echo "$PYTHON_MAJOR_VERSION" && \
#     export PYTHON_VERSION="$PYTHON_MAJOR_VERSION"
# 
# ENV PYTHON_MAJOR_VERSION="$(echo $PYTHON_VERSION | cut -d'.' -f1,2)"

## -- System & Python Dependencies Layer

RUN apt-get -y update
RUN apt-get -y install build-essential wget make \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
    python3-pip python3-dev
RUN apt-get - autoremove -yqq --purge
RUN apt-get -y clean
RUN rm -rf /var/lib/apt/lists/*

# # download-extract-remove-Python-pkg
RUN wget "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" \
    && tar -xf "Python-$PYTHON_VERSION.tgz" \
    && rm -rf "Python-$PYTHON_VERSION.tgz"

## -- Application Layer

# move directory
WORKDIR "/Python-$PYTHON_VERSION"

# configure the build with optimization flags
RUN ./configure --enable-optimizations

# build Python using multiple processors to speed up
RUN make -j$(nproc)

# install Python on system
RUN make altinstall
# RUN make && make install

# add alias-command to run python
RUN echo "alias python=/usr/local/bin/python$PYTHON_MAJOR_VERSION" >> ~/.bashrc

# add pip and Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir wheel

ENV SHARED_WORKSPACE=${SHARED}

# -- Runtime

VOLUME ${SHARED}

CMD ["bash"]