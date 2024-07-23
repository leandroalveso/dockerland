FROM openjdk:11-jre-slim AS AIRBYTE

RUN apt-get update -y && apt-get install -y curl

RUN curl -LsfS https://get.airbyte.com | bash -

RUN abctl local install

CMD ["bash"]
# abctl