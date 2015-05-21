FROM java:7-jre

MAINTAINER Daniel Zohar <daniel@memrise.com>

ENV SNOWPLOW_SOURCE_ZIP snowplow_kinesis_r65_scarlet_rosefinch.zip
ENV JAR_FILE snowplow-kinesis-enrich-0.5.0

RUN wget https://bintray.com/artifact/download/snowplow/snowplow-generic/${SNOWPLOW_SOURCE_ZIP} \
    && unzip ${SNOWPLOW_SOURCE_ZIP} \
    && rm ${SNOWPLOW_SOURCE_ZIP} \
    && mv ${JAR_FILE} keep_${JAR_FILE} \
    && rm -f snowplow* \
    && mv keep_${JAR_FILE} snowplow-kinesis-enrich.jar \
    && mkdir -p /etc/snowplow/enrichments/

COPY config/enrich.conf /etc/snowplow/enrich.conf
COPY config/resolver.json /etc/snowplow/resolver.json

ENTRYPOINT ["/usr/bin/java", "-jar", "snowplow-kinesis-enrich.jar", "--config", "/etc/snowplow/enrich.conf", \
            "--resolver", "file:/etc/snowplow/resolver.json", "--enrichments", "file:/etc/snowplow/enrichments/"]


