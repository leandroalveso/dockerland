# Layer: Base Image

FROM bitnami/spark:3.5.0 AS base-node

# Layer: Final Images

FROM base-node AS computing-node
