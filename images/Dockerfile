FROM ghcr.io/thin-edge/tedge-demo-main-systemd:latest

COPY dist/tedge-inventory*.deb /opt/plugins/
RUN dpkg -i /opt/plugins/tedge-inventory-plugin_*.deb
