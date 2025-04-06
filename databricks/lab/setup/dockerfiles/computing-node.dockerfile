# Layer: Base Image

ARG SPARK_VERSION=3.5.0

FROM bitnami/spark:${SPARK_VERSION} AS base-node

# Layer: Final Images

FROM base-node AS computing-node
