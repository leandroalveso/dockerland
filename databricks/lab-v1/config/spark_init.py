import os
import findspark
from pyspark.sql import SparkSession

findspark.init()

def create_spark_session(
    name: str = "Databricks",
    master: str = "spark://node-master:7077",
    driver_memory: str = "4g",
    executor_memory: str = "6g",
    storage_endpoint: str = "http://object-storage:9000",
    storage_access_key: str = os.environ.get("STORAGE_ACCESS_KEY"),
    storage_secret_key: str = os.environ.get("STORAGE_SECRET_KEY"),
    delta_enabled: bool = False
) -> SparkSession:
    """Create a properly configured Spark session"""
    if delta_enabled:
        spark = (
            SparkSession.builder
            .appName(name)
            .config("spark.driver.extraJavaOptions", "-Xss4M")
            .config("spark.executor.extraJavaOptions", "-Xss4M")
            .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
            .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
            .config("spark.driver.memory", driver_memory)
            .config("spark.executor.memory", executor_memory)
            .config("spark.sql.adaptive.enabled", "true")
            .config("spark.hadoop.fs.s3a.endpoint", storage_endpoint)
            .config("spark.hadoop.fs.s3a.access.key", storage_access_key)
            .config("spark.hadoop.fs.s3a.secret.key", storage_secret_key)
            .config("spark.hadoop.fs.s3a.path.style.access", "true")
            .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
            .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
            .master(master)
            .getOrCreate()
        )
    else:
        spark = (
            SparkSession.builder
            .appName(name)
            .config("spark.driver.extraJavaOptions", "-Xss4M")
            .config("spark.executor.extraJavaOptions", "-Xss4M")
            .config("spark.driver.memory", driver_memory)
            .config("spark.executor.memory", executor_memory)
            .config("spark.sql.adaptive.enabled", "true")
            .config("spark.hadoop.fs.s3a.endpoint", storage_endpoint)
            .config("spark.hadoop.fs.s3a.access.key", storage_access_key)
            .config("spark.hadoop.fs.s3a.secret.key", storage_secret_key)
            .config("spark.hadoop.fs.s3a.path.style.access", "true")
            .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
            .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
            .master(master)
            .getOrCreate()
        )
    
    return spark
