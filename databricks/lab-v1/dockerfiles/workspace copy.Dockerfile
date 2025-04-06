ARG SPARK_VERSION=3.5.0

FROM jupyter/pyspark-notebook:spark-${SPARK_VERSION}

USER root

# Install OpenJDK 11
# RUN apt-get update && \
#     apt-get install -y \
#         openjdk-11-jdk && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# Set Java environment variables
# ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# ENV PATH=$PATH:$JAVA_HOME/bin

# Install additional Python packages
RUN pip install --no-cache-dir \
    delta-spark==3.3.0 \
    polars \
    scikit-learn \
    tensorflow \
    mlflow \
    ipython-sql \
    boto3 \
    s3fs \
    findspark

# Create necessary directories
# RUN mkdir -p /home/jovyan/work && \
#     mkdir -p /home/jovyan/.jupyter && \
#     chmod -R 777 /home/jovyan/work

# Set Spark environment variables
# ENV SPARK_HOME=/usr/local/spark
# ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip
# ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Install JupyterLab SQL extension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Install JupyterLab Git extension
# RUN jupyter labextension install @jupyterlab/git

# Configure Spark environment variables
# ENV PYSPARK_PYTHON=/opt/conda/bin/python3
# ENV PYSPARK_DRIVER_PYTHON=/opt/conda/bin/python3

# Create directory for notebooks
RUN mkdir -p /home/jovyan/workspace && \
    chmod -R 777 /home/jovyan/workspace

USER jovyan

# Copy configuration files
COPY ./config/spark-defaults.conf /usr/local/spark/conf/
COPY ./config/jupyter_notebook_config.py /home/jovyan/.jupyter/

# Initialize Spark configuration
COPY ./config/spark_init.py /home/jovyan/workspace/
