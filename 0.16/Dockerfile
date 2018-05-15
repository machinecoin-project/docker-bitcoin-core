FROM ubuntu:16.04

LABEL maintainer.0="Nico Lucciola (@nigho)"

RUN apt-get update -y \
  && apt-get install -y curl git wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

ENV MACHINECOIN_VERSION=0.16.1
ENV MACHINECOIN_VERSION_TAG=0.16.1.2
ENV MACHINECOIN_DATA=/home/machinecoin/.machinecoin
ENV PATH=/opt/machinecoin-${MACHINECOIN_VERSION}/bin:$PATH

RUN wget https://github.com/machinecoin-project/machinecoin-core/releases/download/v${MACHINECOIN_VERSION_TAG}/machinecoin-${MACHINECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

RUN git clone https://github.com/machinecoin-project/sentinel.git /opt/sentinel
COPY sentinel.conf /opt/sentinel/sentinel.conf

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/root/.machinecoin"]
EXPOSE 40332 40333
WORKDIR /root/.machinecoin

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
