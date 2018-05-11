FROM debian:stable-slim

LABEL maintainer.0="Nico Lucciola (@nigho)"

RUN useradd -r machinecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg python-virtualenv git cron wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

ENV MACHINECOIN_VERSION=0.16.0
ENV MACHINECOIN_DATA=/home/machinecoin/.machinecoin
ENV PATH=/opt/machinecoin-${MACHINECOIN_VERSION}/bin:$PATH

RUN wget https://github.com/machinecoin-project/machinecoin-core/releases/download/v${MACHINECOIN_VERSION}/machinecoin-${MACHINECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

# It's time for sentinel
RUN git clone https://github.com/machinecoin-project/sentinel.git /opt/sentinel \
  && virtualenv ./opt/sentinel/venv \
  && ./opt/sentinel/venv/bin/pip install -r /opt/sentinel/requirements.txt

ADD crontab /etc/cron.d/sentinel-cron
RUN chmod 0644 /etc/cron.d/sentinel-cron

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/machinecoin"]
EXPOSE 40332 40333
WORKDIR /machinecoin

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["machinecoind"]
