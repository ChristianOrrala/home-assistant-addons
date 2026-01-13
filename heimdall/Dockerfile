ARG BUILD_FROM
FROM ${BUILD_FROM:-linuxserver/heimdall:latest}

# Labels for Home Assistant
LABEL \
    io.hass.name="Heimdall Dashboard" \
    io.hass.description="Application dashboard and launcher" \
    io.hass.type="addon" \
    io.hass.version="1.0.1"

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

# Copy our custom init script to s6 service directory
COPY run.sh /etc/s6-overlay/s6-rc.d/ha-config/run
RUN chmod a+x /etc/s6-overlay/s6-rc.d/ha-config/run

# Create the s6 service definition
RUN mkdir -p /etc/s6-overlay/s6-rc.d/ha-config \
    && echo "oneshot" > /etc/s6-overlay/s6-rc.d/ha-config/type \
    && touch /etc/s6-overlay/s6-rc.d/ha-config/up \
    && echo "/etc/s6-overlay/s6-rc.d/ha-config/run" > /etc/s6-overlay/s6-rc.d/ha-config/up \
    && mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d \
    && touch /etc/s6-overlay/s6-rc.d/user/contents.d/ha-config

# Set working directory
WORKDIR /app
