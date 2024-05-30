# https://airflow.apache.org/docs/docker-stack/build.html
ARG USER

FROM apache/airflow:2.9.1

# ENV AIRFLOW__CORE__EXECUTOR=CeleryExecutor
# ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow*54321@airflowdb/airflow
# ENV AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://airflow:airflow*54321@airflowdb/airflow
# ENV AIRFLOW__CELERY__BROKER_URL=redis://:@redis:6379/0
# ENV AIRFLOW__CORE__FERNET_KEY=''
# ENV AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION='true'
# ENV AIRFLOW__CORE__LOAD_EXAMPLES='false'
# ENV AIRFLOW__API__AUTH_BACKENDS='airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session'
# # Use simple http server on scheduler for health checks
# # See https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/logging-monitoring/check-health.html#scheduler-health-check-server
# ENV AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK='true'
# # WARNING: Use _PIP_ADDITIONAL_REQUIREMENTS option ONLY for a quick checks
# # for other purpose (development, test and especially production usage) build/extend Airflow image.
# ENV _PIP_ADDITIONAL_REQUIREMENTS=${_PIP_ADDITIONAL_REQUIREMENTS:-}

# msodbcsql17 unixodbc-dev g++ unixodbc git procps vim

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends openjdk-17-jre-headless \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER "${USER}"

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# RUN pip install --no-cache-dir "apache-airflow[async,celery,elasticsearch,kubernetes,postgres,redis,ssh,statsd,virtualenv]==${AIRFLOW_VERSION}"
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" \
    apache-airflow-providers-apache-spark==2.1.3