FROM ubuntu

# ----------------------------------------------------------------------------
# Install misc
# ----------------------------------------------------------------------------
RUN \
    apt-get update && apt-get install -y \
    wget \
    curl \
    bash \
    openjdk-7-jdk

# ----------------------------------------------------------------------------
# Install elastic-search
# ----------------------------------------------------------------------------
RUN \
    export VERSION=1.5.1 && \
    curl -o /tmp/elasticsearch-${VERSION}.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${VERSION}.tar.gz && \
    tar xvzf /tmp/elasticsearch-${VERSION}.tar.gz -C /usr/share && \
    rm /tmp/elasticsearch-${VERSION}.tar.gz && \
    /usr/share/elasticsearch-${VERSION}/bin/plugin --install lmenezes/elasticsearch-kopf

# Persist data
VOLUME /usr/share/elasticsearch-1.5.1/data

ENV ELASTIC_SEARCH /usr/share/elasticsearch-1.5.1

# ----------------------------------------------------------------------------
# Install kibana
# ----------------------------------------------------------------------------
RUN \
    export VERSION=4.1.0 && \
    curl -o /tmp/kibana-${VERSION}-linux-x64.tar.gz https://download.elastic.co/kibana/kibana/kibana-${VERSION}-linux-x64.tar.gz && \
    tar xvzf /tmp/kibana-${VERSION}-linux-x64.tar.gz -C /usr/share && \
    rm /tmp/kibana-${VERSION}-linux-x64.tar.gz

ENV KIBANA /usr/share/kibana-4.1.0-linux-x64

# ----------------------------------------------------------------------------
# Install logstash
# ----------------------------------------------------------------------------
RUN \
    export VERSION=1.5.1 && \
    curl -o /tmp/logstash-${VERSION}.tar.gz https://download.elasticsearch.org/logstash/logstash/logstash-${VERSION}.tar.gz && \
    tar xvzf /tmp/logstash-${VERSION}.tar.gz -C /usr/share && \
    rm /tmp/logstash-${VERSION}.tar.gz && \
    mkdir /home/config

VOLUME /home/config

COPY config/logstash.conf /home/config/

ENV LOGSTASH /usr/share/logstash-1.5.1

# Public port(s)
EXPOSE 9200 5601

CMD nohup ${ELASTIC_SEARCH}/bin/elasticsearch & \
    nohup ${KIBANA}/bin/kibana & \
    nohup ${LOGSTASH}/bin/logstash -f /home/config/logstash.conf & \
    tail -f /dev/null