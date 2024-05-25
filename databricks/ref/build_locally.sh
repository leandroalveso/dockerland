docker build -f .\dockerfiles\base.dockerfile -t base . 
docker build -f .\dockerfiles\spark.dockerfile -t spark-base .

docker build -f .\dockerfiles\jupyterlab.dockerfile -t jupyterlab .
docker build -f .\dockerfiles\spark-master.dockerfile -t spark-master .
docker build -f .\dockerfiles\spark-worker.dockerfile -t spark-worker .

docker compose up -d