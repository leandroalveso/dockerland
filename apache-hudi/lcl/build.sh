#!/bin/bash
#
# -- Build Apache Hudi Standalone Cluster Docker Images

# ----------------------------------------------------------------------------------------------------------------------
# -- Variables ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

BUILD_DATE="$(date -u +'%Y-%m-%d')"
SPARK_VERSION="3.4.1"
SPARK_VERSION_MAJOR="3"
HADOOP_VERSION="3"
HUDI_VERSION="0.14.1"
DELTA_SPARK_VERSION="3.2.0"
DELTALAKE_VERSION="0.17.4"
JUPYTERLAB_VERSION="4.2.1"
DELTA_PACKAGE_VERSION="delta-core_2.13:2.4.0"
SPARK_XML_PACKAGE_VERSION="spark-xml_2.13:0.18.0"
SPARKSQL_MAGIC_VERSION="0.0.3"
DELTA_HUDI="delta-hudi_2.13:3.2.0"

# ----------------------------------------------------------------------------------------------------------------------
# -- Functions----------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

function cleanContainers() {

    container="$(docker ps -a | grep 'jupyterlab' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

    container="$(docker ps -a | grep 'hudi-worker' -m 1 | awk '{print $1}')"
    while [ -n "${container}" ];
    do
      docker stop "${container}"
      docker rm "${container}"
      container="$(docker ps -a | grep 'hudi-worker' -m 1 | awk '{print $1}')"
    done

    container="$(docker ps -a | grep 'hudi-master' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

    container="$(docker ps -a | grep 'hudi-base' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

    container="$(docker ps -a | grep 'base' | awk '{print $1}')"
    docker stop "${container}"
    docker rm "${container}"

}

function cleanImages() {

      docker rmi -f "$(docker images | grep -m 1 'jupyterlab' | awk '{print $3}')"

      docker rmi -f "$(docker images | grep -m 1 'hudi-worker' | awk '{print $3}')"
      docker rmi -f "$(docker images | grep -m 1 'hudi-master' | awk '{print $3}')"
      docker rmi -f "$(docker images | grep -m 1 'hudi' | awk '{print $3}')"

      docker rmi -f "$(docker images | grep -m 1 'hudi-base' | awk '{print $3}')"

}

function cleanVolume() {
  docker volume rm "distributed-file-system"
}

function buildImages() {

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      --build-arg delta_spark_version="${DELTA_SPARK_VERSION}" \
      --build-arg deltalake_version="${DELTALAKE_VERSION}" \
      -f base.dockerfile \
      -t hudi-base:latest .

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      --build-arg delta_spark_version="${DELTA_SPARK_VERSION}" \
      --build-arg deltalake_version="${DELTALAKE_VERSION}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg hadoop_version="${HADOOP_VERSION}" \
      --build-arg delta_package_version="${DELTA_PACKAGE_VERSION}" \
      --build-arg spark_xml_package_version="${SPARK_XML_PACKAGE_VERSION}" \
      -f hudi.dockerfile \
      -t hudi:latest .

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      -f master.dockerfile \
      -t hudi-master:latest .

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      -f worker.dockerfile \
      -t hudi-worker:latest .

    docker build \
      --build-arg build_date="${BUILD_DATE}" \
      --build-arg scala_version="${SCALA_VERSION}" \
      --build-arg delta_spark_version="${DELTA_SPARK_VERSION}" \
      --build-arg deltalake_version="${DELTALAKE_VERSION}" \
      --build-arg spark_version="${SPARK_VERSION}" \
      --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
      --build-arg sparksql_magic_version="${SPARKSQL_MAGIC_VERSION}" \
      -f jupyterlab.dockerfile \
      -t jupyterlab:latest .

}

# ----------------------------------------------------------------------------------------------------------------------
# -- Main --------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------

cleanContainers;
cleanImages;
cleanVolume;
buildImages;