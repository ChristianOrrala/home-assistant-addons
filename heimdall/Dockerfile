ARG BUILD_FROM
FROM ${BUILD_FROM:-linuxserver/heimdall:latest}

# Labels for Home Assistant
LABEL \
    io.hass.name="Heimdall Dashboard" \
    io.hass.description="Application dashboard and launcher" \
    io.hass.type="addon" \
    io.hass.version="1.0.0"

# Install bashio for Home Assistant integration
RUN apk add --no-cache \
    bash \
    curl \
    jq

# Download and install bashio
RUN curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
    | tar -xzf - -C /tmp \
    && mv /tmp/bashio-0.16.2/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio-0.16.2

# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Set working directory
WORKDIR /app

# Entry point
ENTRYPOINT ["/run.sh"]
