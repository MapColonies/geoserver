ARG GEOSERVER_BASE_IMAGE

FROM ${GEOSERVER_BASE_IMAGE}

ARG GEOSERVER_VERSION
ARG OTEL_VERSION
ARG LOG4J_VERSION
ARG JMX_PROMETHEUS_VERSION

ENV OTEL_SERVICE_NAME=geoserver
ENV RUN_AS_ROOT=true
ENV OTEL_LOGS_EXPORTER=none

USER root

RUN wget --directory-prefix=/otel https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/${OTEL_VERSION}/opentelemetry-javaagent.jar \
    && wget --directory-prefix=${CATALINA_HOME}/webapps/geoserver/WEB-INF/lib https://search.maven.org/remotecontent?filepath=org/apache/logging/log4j/log4j-layout-template-json/${LOG4J_VERSION}/log4j-layout-template-json-${LOG4J_VERSION}.jar \
    && wget --directory-prefix=/jmx https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar \
    && mv /jmx/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar /jmx/jmx_prometheus_javaagent.jar

RUN mkdir -p "${GEOSERVER_DATA_DIR}" \
    "${CERT_DIR}" \
    "${FOOTPRINTS_DATA_DIR}" \
    "${FONTS_DIR}" \
    "${GEOWEBCACHE_CACHE_DIR}" \
    "${GEOSERVER_HOME}" \
    "${EXTRA_CONFIG_DIR}" \ 
    "/docker-entrypoint-geoserver.d"

RUN chgrp -R 0 ${CATALINA_HOME} /opt /usr/local/tomcat /settings /etc/certs \
    /scripts /tmp/ /home /community_plugins/ \
    ${GEOSERVER_HOME} /usr/share/fonts/
RUN chmod -R g=u ${CATALINA_HOME} /opt /usr/local/tomcat /settings /etc/certs \
    /scripts /tmp/ /home /community_plugins/ \
    ${GEOSERVER_HOME} /usr/share/fonts/

RUN sed -i 's/chmod o+rw "\${CERT_DIR}";gwc_file_perms ;find \${CATALINA_HOME}\/conf\/ -type f -exec chmod 400 {} \\;//g' /scripts/entrypoint.sh

RUN mkdir /.postgresql && chmod g+w /.postgresql

COPY jmx_config.yaml /jmx/config.yaml
COPY cert-start.sh /scripts/cert-start.sh

RUN useradd -ms /bin/bash user && usermod -a -G root user

RUN echo ${GEOSERVER_VERSION} 
RUN echo ${GEOSERVER_VERSION} | awk '{print ($1 >= 2.27)}'
# Install GeoServer ogcapi-features-plugin. Available in GeoServer 2.27 and later.
# This plugin is required for the GeoServer to support OGC API Features.
# The plugin is not included in the GeoServer base image by default (right to May 8th 2025).
RUN if [ -n "${GEOSERVER_VERSION}" ] && [ "$(echo ${GEOSERVER_VERSION} | awk '{print ($1 >= 2.27)}')" -eq 1 ]; then \
    mkdir /tmp/ogcfeaturesplugin && wget --directory-prefix=/tmp/ogcfeaturesplugin https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}.x/ext-latest/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-ogcapi-features-plugin.zip \
    && unzip /tmp/ogcfeaturesplugin/geoserver-${GEOSERVER_VERSION}-SNAPSHOT-ogcapi-features-plugin.zip -d /tmp/ogcfeaturesplugin \
    && cp -r /tmp/ogcfeaturesplugin/* ${CATALINA_HOME}/webapps/geoserver/WEB-INF/lib \
    && rm -rf /tmp/ogcfeaturesplugin; \
fi

USER user

ENTRYPOINT ["/bin/bash", "/scripts/cert-start.sh"]