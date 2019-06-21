FROM mdillon/postgis:9.6

ENV TZ 'Europe/Amsterdam'
ENV PGTZ 'Europe/Amsterdam'

RUN echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        curl \
        lzop \
        pv \
        daemontools \
        tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /usr/local/bin && curl -L https://github.com/wal-g/wal-g/releases/download/v0.2.9/wal-g.linux-amd64.tar.gz | tar xzf -

COPY initdb/initdb-wal-g.sh /docker-entrypoint-initdb.d/

COPY *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh