FROM python:3.11-slim

RUN pip install --no-cache-dir \
    mlflow==2.20.2 \
    psycopg2-binary \
    boto3 \
    s3fs

EXPOSE 5000
