ARG PYTHON_VERSION=3.11

FROM python:${PYTHON_VERSION}-alpine AS BUILDER

RUN apk update

RUN apk add git

RUN pip install --upgrade pip wheel

CMD ["/bin/sh"]