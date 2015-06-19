# ELK-docker

A docker running Elastic-search, Logstash, and Kibana

## Quickstart

Put logstash configuration in `config/logstash.conf`.

Build the docker image:

``` bash
docker build -t <image-name> .
```

Run a docker container:

``` bash
docker run -d -p 9200:9200 -p 5601:5601 --name <container-name> <image-name>
```

You can view messages received by Elastic-search at http://\<hostname\>:9200/_search?pretty.
Or you can view messages in Kibana at http://\<hostname\>:5601.