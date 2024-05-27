FROM databricks-base:latest

# -- Layer: Image Metadata

ENV BUILD_DATE="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name="JupyterLab"
LABEL org.label-schema.description="JupyterLab image"

# -- Layer: Notebooks and data

# -- Layer: JupyterLab + Python kernel for PySpark

ARG jupyterlab_version="4.2.1"
ARG spark_version="3.4.3"
ARG spark_version_major="3.4"
ARG sparksql_magic_version="0.0.3"

RUN pip3 install --no-cache-dir jupyterlab==${jupyterlab_version} \
    pyspark==${spark_version} sparksql-magic==${sparksql_magic_version} \
    requests confluent-kafka airflow \
    numpy pyarrow pandas polars \
    scipy statsmodels scikit-learn \
    tensorflow tensorflow-probability tf-agents torch mlflow mlflow-vizmod bigmlflow \
    seaborn

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=