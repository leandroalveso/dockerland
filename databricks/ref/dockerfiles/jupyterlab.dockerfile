FROM base

# -- Layer: Image Metadata

ARG build_date

ENV build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Data Engineering wih Apache Spark and Delta Lake Cookbook - JupyterLab Image"
LABEL org.label-schema.description="JupyterLab image"

# -- Layer: Notebooks and data

# -- Layer: JupyterLab + Python kernel for PySpark

ARG spark_version
ARG jupyterlab_version
ARG sparksql_magic_version

ENV spark_version="3.4.1"
ENV jupyterlab_version="4.0.2"
ENV sparksql_magic_version="0.0.3"

RUN pip3 install --no-cache-dir \
    pyspark==${spark_version} \
    jupyterlab==${jupyterlab_version} \
    sparksql-magic==${sparksql_magic_version} \
    kafka-python requests pandas polars scipy statsmodels scikit-learn tensorflow

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=;python