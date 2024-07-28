FROM python:3.11-slim-buster

WORKDIR /app

COPY ./config/requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY ./app .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--log-level", "info", "--workers", "1"]