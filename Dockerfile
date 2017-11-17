FROM postgres:9.6.5
MAINTAINER Andreas Wålm <andreas@walm.net>
MAINTAINER Pentascape <devops@pentascape.com>

RUN apt-get update \
    && apt-get install -y build-essential git-core libv8-dev curl postgresql-server-dev-$PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*

# install plv8
ENV PLV8_BRANCH r1.4

RUN cd /tmp && git clone -b $PLV8_BRANCH https://github.com/plv8/plv8.git \
  && cd /tmp/plv8 \
  && make all install

# install pg_prove
RUN curl -LO http://xrl.us/cpanm \
    && chmod +x cpanm \
    && ./cpanm TAP::Parser::SourceHandler::pgTAP


# install pgtap
ENV PGTAP_VERSION v0.98.0
RUN git clone git://github.com/theory/pgtap.git \
    && cd pgtap && git checkout tags/$PGTAP_VERSION \
    && make

VOLUME ["/t"]

ADD ./test.sh /usr/local/bin/test.sh
RUN chmod +x /usr/local/bin/test.sh
