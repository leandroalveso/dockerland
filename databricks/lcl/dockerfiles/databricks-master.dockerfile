ARG spark_version

#FROM databricks:${spark_version}
FROM databricks:latest

# -- Layer: Image Metadata

ARG BUILD_DATE="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.description="Spark master image"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime

EXPOSE 8080 7077

CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out