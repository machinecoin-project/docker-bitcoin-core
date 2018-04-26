# Build stage for BerkeleyDB
FROM alpine as berkeleydb

RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base
RUN apk --no-cache add libressl

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

RUN wget https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for Machinecoin Core
FROM alpine as machinecoin-core

COPY --from=berkeleydb /opt /opt

RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add boost-dev
RUN apk --no-cache add build-base
RUN apk --no-cache add chrpath
RUN apk --no-cache add file
RUN apk --no-cache add gnupg
RUN apk --no-cache add libevent-dev
RUN apk --no-cache add libressl
RUN apk --no-cache add libressl-dev
RUN apk --no-cache add libtool
RUN apk --no-cache add linux-headers
RUN apk --no-cache add protobuf-dev
RUN apk --no-cache add zeromq-dev
RUN set -ex \
  && for key in \
    90C8019E36C2E964 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV MACHINECOIN_VERSION=0.14.2
ENV MACHINECOIN_PREFIX=/opt/machinecoin-${MACHINECOIN_VERSION}

RUN wget https://github.com/machinecoin-project/machinecoin-core/releases/machinecoin-core-${MACHINECOIN_VERSION}/SHA256SUMS.asc
RUN wget https://github.com/machinecoin-project/machinecoin-core/releases/machinecoin-core-${MACHINECOIN_VERSION}/machinecoin-${MACHINECOIN_VERSION}.tar.gz
RUN gpg --verify SHA256SUMS.asc
RUN grep " machinecoin-${MACHINECOIN_VERSION}.tar.gz\$" SHA256SUMS.asc | sha256sum -c -
RUN tar -xzf *.tar.gz

WORKDIR /machinecoin-${MACHINECOIN_VERSION}

RUN sed -i '/DIST_SUBDIRS/a\ARFLAGS=cr' src/Makefile.am
RUN sed -i '/AC_PREREQ/a\ARFLAGS=cr' configure.ac
RUN sed -i '/AC_PREREQ/a\AR_FLAGS=cr' src/univalue/configure.ac
RUN sed -i '/AX_PROG_CC_FOR_BUILD/a\AR_FLAGS=cr' src/secp256k1/configure.ac
RUN sed -i s:sys/fcntl.h:fcntl.h: src/compat.h
RUN ./autogen.sh
RUN ./configure LDFLAGS=-L`ls -d /opt/db*`/lib/ CPPFLAGS=-I`ls -d /opt/db*`/include/ \
    --prefix=${MACHINECOIN_PREFIX} \
    --mandir=/usr/share/man \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --with-gui=no \
    --with-utils \
    --with-libs \
    --with-daemon
RUN make -j4
RUN make install
RUN strip ${MACHINECOIN_PREFIX}/bin/machinecoin-cli
RUN strip ${MACHINECOIN_PREFIX}/bin/machinecoin-tx
RUN strip ${MACHINECOIN_PREFIX}/bin/machinecoind
RUN strip ${MACHINECOIN_PREFIX}/lib/libmachinecoinconsensus.a
RUN strip ${MACHINECOIN_PREFIX}/lib/libmachinecoinconsensus.so.0.0.0

# Build stage for compiled artifacts
FROM alpine

LABEL maintainer.0="Nico Lucciola (@nigho)"

RUN adduser -S machinecoin
RUN apk --no-cache add \
  boost \
  boost-program_options \
  libevent \
  libressl \
  libzmq \
  su-exec

ENV MACHINECOIN_DATA=/home/machinecoin/.machinecoin
ENV MACHINECOIN_VERSION=0.14.2
ENV MACHINECOIN_PREFIX=/opt/machinecoin-${MACHINECOIN_VERSION}
ENV PATH=${MACHINECOIN_PREFIX}/bin:$PATH

COPY --from=machinecoin-core /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/machinecoin/.machinecoin"]

EXPOSE 40332 40333 50332 50333 60332 60333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["machinecoind"]
