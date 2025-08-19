: ${ARCH:=amd64}
# Ubuntu noble
: ${SUITE:=noble}

podman build \
    -f Containerfile \
    --arch=$ARCH \
    --build-arg="SUITE=${SUITE}" \
    -t ubuntu:${SUITE}
