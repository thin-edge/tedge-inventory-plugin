#!/bin/bash
# -------------------------------------------
# Build linux packages
# -------------------------------------------
set -e

# clean dist
if [ -d dist ]; then
    rm -rf dist
fi

mkdir -p dist

if [ $# -gt 0 ]; then
    export SEMVER="$1"
fi

if [ -n "$SEMVER" ]; then
    echo "Using version: $SEMVER"
fi

packages=(
    deb
    apk
    rpm
)

for package_type in "${packages[@]}"; do
    echo ""
    # meta package
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.yaml

    # core
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.core.yaml

    # plugins
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.c8y-hardware.yaml
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.c8y-position.yaml
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.device-certificate.yaml
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.device-os.yaml
    nfpm package --packager "$package_type" --target ./dist/ -f nfpm.device-network.yaml
done

echo "Created all linux packages"