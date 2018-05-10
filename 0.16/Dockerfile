FROM debian:stable-slim

LABEL maintainer.0="Nico Lucciola (@nigho)"

RUN useradd -r machinecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg python-virtualenv git cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

ENV MACHINECOIN_VERSION=0.16.0
ENV MACHINECOINCOIN_DATA=/home/machinecoin/.machinecoin
ENV MACHINECOINCOIN_CONFIG=/home/machinecoin/.machinecoin/machinecoin.conf
ENV PATH=/opt/machinecoin-${MACHINECOIN_VERSION}/bin:$PATH

RUN curl -fSL https://github.com/machinecoin-project/machinecoin-core/releases/download/v${MACHINECOIN_VERSION}/machinecoin-${MACHINECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

# It's time for sentinel
RUN git clone https://github.com/machinecoin-project/sentinel.git /opt/sentinel \
  && virtualenv ./opt/sentinel/venv \
  && ./opt/sentinel/venv/bin/pip install -r requirements.txt

ADD crontab /etc/cron.d/sentinel-cron
RUN chmod 0644 /etc/cron.d/sentinel-cron

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/machinecoin/.machinecoin"]

EXPOSE 40332 40333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["machinecoind"]
