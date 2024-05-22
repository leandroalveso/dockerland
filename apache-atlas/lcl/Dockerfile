ARG debian_buster_image_tag=11-jre-slim

FROM openjdk:${debian_buster_image_tag}

RUN apt-get update && wget tar

ARG apache_atlas_version=2.3.0
ARG apache_atlas_downloads_url=https://www.apache.org/dyn/closer.cgi/atlas/2.3.0/apache-atlas-2.3.0-sources.tar.gz

RUN wget -O https://www.apache.org/dyn/closer.cgi/atlas/2.3.0/apache-atlas-2.3.0-sources.tar.gz -q /temp/apache-atlas-2.3.0-sources.tar.gz
RUN mv /tmp/apache-atlas-2.3.0-sources.tar.gz .
RUN tar -xzvf /temp/apache-atlas-2.3.0-sources.tar.gz
RUN rm -rf /temp/apache-atlas-2.3.0-sources.tar.gz

CMD ["bash"]