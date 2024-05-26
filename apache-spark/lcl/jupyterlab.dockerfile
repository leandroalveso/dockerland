ARG debian_buster_image_tag=11-jre-slim

FROM openjdk:${debian_buster_image_tag} AS spark-base

# -- Layer: OS + Python 3.11

ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace} \
    && apt-get update -y \
    && apt-get install -y python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${shared_workspace}

# -- Runtime

VOLUME ${shared_workspace}
CMD ["bash"]

FROM spark-base

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="JupyterLab"
LABEL org.label-schema.description="JupyterLab image"

# -- Layer: Notebooks and data

# -- Layer: JupyterLab + Python kernel for PySpark

ARG spark_version="3.4.1"
ARG jupyterlab_version="4.2.1"
ARG sparksql_magic_version="0.0.3"

RUN pip3 install --no-cache-dir \
    pyspark==${spark_version} \
    jupyterlab==${jupyterlab_version} \
    sparksql-magic==${sparksql_magic_version} \
    requests numpy pandas polars scipy statsmodels scikit-learn tensorflow

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=;python