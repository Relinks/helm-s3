#!/usr/bin/env sh

# This emulates GOPATH presence for go tool.
# This is need because helm installs plugins into ~/.helm/plugins.

version="${HELM_S3_PLUGIN_VERSION:-}"
if [ -z "${version}" ]; then
  version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
fi

# Build the linux release
go build -o bin/helms3 -ldflags "-X main.version=${version}" ./cmd/helms3

# Build the windows release
GOOS=windows GOARCH=amd64 go build -o bin/helms3.exe -ldflags "-X main.version=${version}" ./cmd/helms3

# Package the releases
tar -czf s3-windows.tar.gz plugin.yaml bin/helms3.exe LICENSE
tar -czf s3.tar.gz plugin.yaml bin/helms3 LICENSE
