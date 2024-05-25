FROM databricks:latest

# -- Layer: Image Metadata

ARG build_date

ENV build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="JupyterLab"
LABEL org.label-schema.description="JupyterLab image"

# -- Layer: Notebooks and data

# ADD docker/jupyterlab/kafka-producer.py /

# -- Layer: JupyterLab + Python kernel for PySpark

ARG jupyterlab_version
ARG spark_version
ARG spark_version_major
ARG sparksql_magic_version

ENV jupyterlab_version="4.0.2"
ENV spark_version="3.4.1"
ENV spark_version_major="3.4"
ENV sparksql_magic_version="0.0.3"

RUN pip3 install --no-cache-dir wget==3.2 \
    pyspark==${spark_version} \
    jupyterlab==${jupyterlab_version} \
    sparksql-magic==${sparksql_magic_version} \
    kafka-python pandas polars scipy scikit-learn tensorflow

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=;python