FROM python:3.11-slim

#-- update-image

RUN apt-get -y update \
    && apt-get -y upgrade \
    && pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y procps \
    && rm -rf /var/lib/apt/lists/*

#-- create a usergroup and user

RUN groupadd mlflow && useradd --create-home -g mlflow "${MLFLOW_USER}"
ENV PATH /home/"${MLFLOW_USER}"/.local/bin:${PATH}

WORKDIR /home/"${MLFLOW_USER}"/mlflow
USER "${MLFLOW_USER}"

#-- install-MLflow

RUN pip install --no-cache-dir \
    psycopg2-binary \
    mlflow mlflow-vizmod bigmlflow

#ENV BACKEND_STORE_URI sqlite:///mlflow.db
ENV BACKEND_STORE_URI postgresql+psycopg2://$MLFLOW_USER:$MLFLOW_SECRET@$MLFLOW_HOSTNAME:$MLFLOW_PORT/$MLFLOW_DB

EXPOSE 5000

CMD mlflow server \
    --backend-store-uri ${BACKEND_STORE_URI} \
    --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
    --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
    --no-serve-artifacts \
    --host 0.0.0.0 \
    --port 5000