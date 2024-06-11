FROM apache-spark-base:latest as pyspark-jupyterlab

# -- Layer: Image Metadata

ARG BUILD_DATE="$(date -u +'%Y-%m-%d')"
ARG SPARK_VERSION=3.5.1
ARG JUPYTERLAB_VERSION=4.2.1
ARG SPARKSQL_MAGIC_VERSION=0.0.3

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="JupyterLab for Apache Spark"
LABEL org.label-schema.description="JupyterLab for Apache Spark Image"

# -- Layer: JupyterLab + Python kernel for PySpark

RUN pip3 install --no-cache-dir \
    jupyterlab==${JUPYTERLAB_VERSION} \
    pyspark==${SPARK_VERSION} \
    sparksql-magic==${SPARKSQL_MAGIC_VERSION}

COPY ./dockerfiles/requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

# -- Layer: Runtime

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=;python