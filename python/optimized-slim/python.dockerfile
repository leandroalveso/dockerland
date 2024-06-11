ARG PYTHON_VERSION
ARG PYTHON_MAJOR_VERSION

FROM --platform=arm64 debian:stable-slim AS BUILDER

ENV PYTHON_VERSION=3.11.9
ENV PYTHON_MAJOR_VERSION=3.11

RUN apt-get update \
    && apt-get install build-essential wget make \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
    python3-pip python3-dev \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# # download-extract-remove-Python-pkg
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -xf "Python-$PYTHON_VERSION.tgz" \
    && rm -rf "Python-$PYTHON_VERSION.tgz"

# move directory
WORKDIR "/Python-$PYTHON_VERSION"

# configure the build with optimization flags
RUN ./configure --enable-optimizations

# build Python using multiple processors to speed up
RUN make -j$(nproc)

# install Python on system
RUN make altinstall
# RUN make
# RUN make install

# add alias-command to run python
RUN echo 'alias python=/usr/local/bin/python$PYTHON_MAJOR_VERSION' >> ~/.bashrc

# add pip and Python dependencies
RUN pip install --upgrade --break-system-packages pip
RUN pip install --no-cache-dir --break-system-packages wheel

# return on dir tree
WORKDIR /

CMD ["/bin/sh"]