#!/bin/bash
USERNAME="admin*12345"
PASSWORD="psswrd*12345"

# Install MinIO client
mc alias set myminio http://localhost:9000 admin*12345 psswrd*12345

# Create buckets
mc mb myminio/mlflow
mc mb myminio/delta
mc mb myminio/spark-events
