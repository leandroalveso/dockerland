ARG spark_version="3.4.1"
ARG hudi_version="0.14.1"

FROM hudi

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Apache Hudi worker"
LABEL org.label-schema.description="Apache Hudi (with Apache Spark) worker image"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime

EXPOSE 8081

CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out