# ./dockerfiles/workspace.Dockerfile
ARG SPARK_VERSION=3.5.0
FROM jupyter/pyspark-notebook:spark-${SPARK_VERSION}

USER root

# Install Python packages
RUN pip install --no-cache-dir \
    delta-spark==3.3.0 \
    mlflow \
    ipython-sql \
    boto3 \
    s3fs \
    findspark
    # scikit-learn \
    # tensorflow \
    # pandera[polars] \
    # minio \
    # pyarrow \
    # polars \
    # -r /home/jovyan/requirements.txt

# Create workspace directory
RUN mkdir -p /home/jovyan/workspace && \
    chmod -R 777 /home/jovyan/workspace

# Install JupyterLab extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

USER jovyan

# Copy configuration files
COPY --chown=jovyan:users ./config/spark-defaults.conf /usr/local/spark/conf/
COPY --chown=jovyan:users ./config/jupyter_notebook_config.py /home/jovyan/.jupyter/
COPY --chown=jovyan:users ./config/spark_init.py /home/jovyan/workspace/
