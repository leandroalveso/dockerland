FROM python:3.11-alpine AS BUILDER

RUN apk update

RUN apk add --no-cache git gcc rust cargo

RUN pip install --upgrade pip wheel maturin

CMD ["/bin/sh"]