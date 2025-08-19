podman build \
    -f Containerfile \
    --arch=amd64 \
    --build-arg="SUITE=sid" \
    -t debian:sid
