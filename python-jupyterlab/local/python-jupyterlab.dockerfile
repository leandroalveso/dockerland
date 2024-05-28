FROM python-base:latest

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="JupyterLab for Apache Spark"
LABEL org.label-schema.description="JupyterLab image"

# -- Layer: Notebooks and data

# -- Layer: JupyterLab + Python kernel for PySpark

ARG spark_version="3.4.1"
ARG jupyterlab_version="4.2.1"
ARG sparksql_magic_version="0.0.3"

RUN pip3 install --no-cache-dir \
    jupyterlab==${jupyterlab_version} \
    pyspark==${spark_version} \
    sparksql-magic==${sparksql_magic_version} \
    requests numpy pandas polars scipy statsmodels scikit-learn tensorflow torch \
    seaborn

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=;python