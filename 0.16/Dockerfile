FROM ubuntu:16.04

LABEL maintainer.0="Nico Lucciola (@nigho)"

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN apt-get update -y \
  && apt-get install -y curl gnupg python-virtualenv git cron wget \
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

# It's time for sentinel
RUN git clone https://github.com/machinecoin-project/sentinel.git /opt/sentinel \
  && virtualenv ./opt/sentinel/venv \
  && ./opt/sentinel/venv/bin/pip install -r /opt/sentinel/requirements.txt \
  && rm /opt/sentinel/sentinel.conf

COPY sentinel.conf /opt/sentinel/sentinel.conf

ADD crontab /etc/cron.d/sentinel-cron
RUN chmod 0600 /etc/cron.d/sentinel-cron

COPY ./services.d /etc/services.d

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/root/.machinecoin"]
EXPOSE 40332 40333
WORKDIR /root/.machinecoin

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
