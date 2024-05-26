ARG spark_version="3.4.1"
ARG hudi_version="0.14.1"

FROM hudi

# -- Layer: Image Metadata

ARG build_date="$(date -u +'%Y-%m-%d')"

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Apache Hudi master"
LABEL org.label-schema.description="Apache Hudi (with Apache Spark) master image"
LABEL org.label-schema.schema-version="1.0"

# -- Runtime

EXPOSE 8080 7077

CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out