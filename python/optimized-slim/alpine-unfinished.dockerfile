ARG PYTHON_VERSION="3.11.8"
ARG PYTHON_MAJOR_VERSION="3.11"

FROM --platform=amd64 alpine:3.20.0 AS BUILDER

ENV PYTHON_VERSION="3.11.8"
ENV PYTHON_MAJOR_VERSION="3.11"

RUN apk --no-cache update
RUN apk add --no-cache \
    alpine-sdk build-base ca-certificates g++ gcc git linux-headers make openssl unzip zip  \
    python3-dev py-pip sqlite wget zlib-dev

# download-extract-remove-Python-pkg
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -xf "Python-$PYTHON_VERSION.tgz" \
    && rm -rf "Python-$PYTHON_VERSION.tgz"

# move directory
RUN cd "Python-$PYTHON_VERSION"

# configure the build with optimization flags
RUN ./configure --enable-optimizations

# build Python using multiple processors to speed up
RUN make -j$(nproc)

# install Python on system
RUN make altinstall

# add alias-command to run python
RUN alias python='/usr/local/bin/python${PYTHON_MAJOR_VERSION}'

# return on dir tree
RUN cd ..

CMD ["/bin/sh"]