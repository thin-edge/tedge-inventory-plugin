FROM ghcr.io/thin-edge/tedge-demo-main-systemd:latest

COPY dist/tedge-inventory*.deb /tmp/
RUN dpkg -i /tmp/*.deb
