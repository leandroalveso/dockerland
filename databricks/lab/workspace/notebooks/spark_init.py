from os import environ

from pyspark.sql import SparkSession


def spark_init(
    job_name: str, 
    driver_memory: int=2,
    executor_memory: int=4,
    max_cores: int=2,
    master_url: str="spark://node-master:7077",
    object_storage_url: str="http://object-manager:9000"
) -> SparkSession:
    spark = SparkSession.builder\
        .appName(job_name) \
        .master(master_url) \
        .config("spark.hadoop.fs.s3a.endpoint", object_storage_url) \
        .config("spark.hadoop.fs.s3a.access.key", environ["OBJECT_STORAGE_ACCESS_USERNAME"]) \
        .config("spark.hadoop.fs.s3a.secret.key", environ["OBJECT_STORAGE_ACCESS_PASSWORD"]) \
        .config("spark.hadoop.fs.s3a.path.style.access", True) \
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
        .config("spark.driver.memory", f"{driver_memory}g") \
        .config("spark.executor.memory", f"{executor_memory}g") \
        .config("spark.cores.max", f"{max_cores}") \
        .getOrCreate()
        # .config("spark.driver.maxResultSize", "4g") \
    
    return spark
