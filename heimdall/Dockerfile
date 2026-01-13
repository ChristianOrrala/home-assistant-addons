ARG BUILD_FROM
FROM ${BUILD_FROM:-linuxserver/heimdall:latest}

# Labels for Home Assistant
LABEL \
    io.hass.name="Heimdall Dashboard" \
    io.hass.description="Application dashboard and launcher" \
    io.hass.type="addon" \
    io.hass.version="1.1.5"

# Install bashio for Home Assistant integration
RUN apk add --no-cache \
    bash \
    jq

# Download and install bashio
RUN curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
    | tar -xzf - -C /tmp \
    && mv /tmp/bashio-0.16.2/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio-0.16.2

# Copy our configuration script to s6 cont-init.d (runs before services start)
COPY run.sh /etc/cont-init.d/99-ha-config
RUN chmod a+x /etc/cont-init.d/99-ha-config
