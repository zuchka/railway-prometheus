FROM prom/prometheus

# copy the Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/prometheus-entrypoint

# expose the Prometheus server port
EXPOSE 9090

# set the entrypoint command
USER root
ENTRYPOINT [ "/usr/local/bin/prometheus-entrypoint" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--storage.tsdb.retention.time=365d", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles", \
             "--web.external-url=http://localhost:9090", \
             "--log.level=info"]
 
