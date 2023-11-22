FROM ghcr.io/thin-edge/tedge-demo-main-systemd:20231105.1

COPY dist/tedge-inventory*.deb /tmp/
RUN dpkg -i /tmp/*.deb
