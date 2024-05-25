ARG spark_version

#FROM databricks:${spark_version}
FROM databricks:latest

# -- Layer: Image Metadata

ARG build_date

ENV build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Spark worker image"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime

EXPOSE 8080

CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out