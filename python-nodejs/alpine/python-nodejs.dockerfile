FROM python:3.11-alpine AS BUILDER

RUN apk update

RUN apk add git nodejs npm

RUN pip install --upgrade pip wheel
RUN npm update -g

CMD ["/bin/sh"]