# DATA LAKEHOUSE

A modern **Data Lakehouse** combines the best features of data lakes and data warehouses to provide a unified data platform.

Here are the key components and benefits:

- **Data Ingestion**:
    - Supports batch and real-time data ingestion from various sources like databases, IoT devices, and streaming platforms.
    - Tools: **Apache Kafka**, **Apache Airflow**, Apache Nifi, AWS Glue, Azure Data Factory, Google Data Flow.
- **Storage**:
    - Utilizes scalable, cost-effective storage solutions. Supports raw, structured, and semi-structured data.
    - Tools: **Apache Hadoop**, **Minio**, Databricks Delta Lake, Amazon S3, Google Cloud Storage, Azure Data Lake Storage Genesis V2.
- **Data Processing**:
    - Provides ETL (Extract, Transform, Load) capabilities. Supports both batch and stream processing.
    - Tools: **Apache Hadoop**, **Apache Airflow**, **Apache Spark**, Databricks Delta Lake, Apache Flink, Databricks.
- **Metadata Management**:
    - Maintains data catalogs and governance policies. Ensures data quality and lineage.
    - Tools: **Apache Atlas**, **Apache Hive-Metastore**, **Apache Amundsen**, AWS Glue Data Catalog.
- **Query Engine**:
    - Allows for SQL-based querying across data stored in the lakehouse. Provides performance optimizations like indexing and caching.
    - Tools: Apache Hive, **Apache Spark**, **Apache Hudi**, Apache Iceberg, Presto, Databricks SQL, AWS Glue/Athena, Azure Synapse Analytics.
- **Data Governance and Security**:
    - Ensures data privacy and compliance with regulations. Implements fine-grained access controls and auditing.
    - Tools: **Apache Atlas**, Apache Ranger, AWS Lake Formation, Azure Purview.
- **Machine Learning and BI Integration**:
    - Supports advanced analytics and machine learning workloads. Integrates with BI tools for reporting and visualization.
    - Tools: **Apache Spark MLlib**, Apache Superset, Jupyter Notebooks, Apache Zeppelin, TensorFlow, Power BI, Tableau.

## GETTING STARTED

This is a solution based on a very good article. Check [here](https://medium.com/@hoshinglee.g/build-a-poor-mans-data-lakehouse-with-docker-502dd422e6fe).

The solutions are organized on:
- **lcl**: allow you to deploy a solution locally with more control. It allows you to make your development.

## REFERENCES
- [Reference Article](https://medium.com/@hoshinglee.g/build-a-poor-mans-data-lakehouse-with-docker-502dd422e6fe)

## COPYRIGHTS
Copyright (c) 2024 Leandro Alves de Oliveira (engleandroalveso@gmail.com).