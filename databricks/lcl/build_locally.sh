docker build -f .\dockerfiles\databricks-base.dockerfile -t databricks-base . 
docker build -f .\dockerfiles\databricks-spark.dockerfile -t databricks .
docker build -f .\dockerfiles\databricks-jupyterlab.dockerfile -t jupyterlab .

docker compose up -d