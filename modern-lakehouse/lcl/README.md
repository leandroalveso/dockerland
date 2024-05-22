# MODERN DATA LAKEHOUSE WITH DOCKER LOCALLY

## GETTING STARTED

- **Data Ingestion**: Apache Kafka and Apache Airflow.
- **Storage**: Minio.
- **Data Processing**: Apache Hadoop, Apache Airflow, Apache Spark.
- **Metadata Management**: Apache Atlas, Apache Hive-Metastore, Apache Amundsen.
- **Query Engine**: Apache Spark and Apache Hudi.
- **Data Governance and Security**: Apache Atlas.
- **Machine Learning and BI Integration**: Apache Spark MLlib

## HOW TO SET UP

```bash
docker compose up minio-init

docker compose up airflow-init

docker compose up -d
```