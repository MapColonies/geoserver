ARG GEOSERVER_BASE_IMAGE

FROM ${GEOSERVER_BASE_IMAGE}

ENV OTEL_SERVICE_NAME=geoserver
ENV RUN_AS_ROOT=true
ENV OTEL_LOGS_EXPORTER=none

USER root

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

RUN sed -i 's/chmod o+rw \"\${CERT_DIR}\"\;gwc_file_perms \;chmod 400 \"\${CATALINA_HOME}\"\/conf\/\*/ /g' /scripts/entrypoint.sh

RUN mkdir /.postgresql && chmod g+w /.postgresql

COPY jmx_config.yaml /jmx/config.yaml
COPY cert-start.sh /scripts/cert-start.sh

RUN useradd -ms /bin/bash user && usermod -a -G root user

USER user

ENTRYPOINT ["/bin/bash", "/scripts/cert-start.sh"]
