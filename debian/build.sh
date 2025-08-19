: ${ARCH:=amd64}
# Debian trixie, sid
: ${SUITE:=trixie}

podman build \
    -f Containerfile \
    --arch=$ARCH \
    --build-arg="SUITE=${SUITE}" \
    -t debian:${SUITE}
