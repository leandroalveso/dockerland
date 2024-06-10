ARG PYTHON_VERSION
ARG PYTHON_MAJOR_VERSION

FROM --platform=arm64 debian:stable-slim AS BUILDER

ENV PYTHON_VERSION="3.11.8"
ENV PYTHON_MAJOR_VERSION="3.11"

RUN apt-get update \
    && apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# # download-extract-remove-Python-pkg
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -xf "Python-$PYTHON_VERSION.tgz" \
    && rm -rf "Python-$PYTHON_VERSION.tgz"

# move directory
WORKDIR "Python-$PYTHON_VERSION"

# configure the build with optimization flags
RUN ./configure --enable-optimizations

# build Python using multiple processors to speed up
RUN make -j$(nproc)

# install Python on system
RUN make altinstall

# add alias-command to run python
RUN alias python='/usr/local/bin/python${PYTHON_MAJOR_VERSION}'

# return on dir tree
WORKDIR /

# install pip/python dependencie
RUN python -m pip install --no-cache --upgrade pip wheel

CMD ["/bin/sh"]