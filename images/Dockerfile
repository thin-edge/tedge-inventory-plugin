ARG TEST_IMAGE=ghcr.io/thin-edge/tedge-demo-main-systemd:latest
FROM ${TEST_IMAGE}

COPY dist/tedge-inventory*.deb /opt/plugins/
RUN dpkg -i /opt/plugins/tedge-inventory-plugin_*.deb
