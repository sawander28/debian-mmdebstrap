
# local registry
podman container run \
    -dt \
    -p 5000:5000 \
    --name registry \
    --volume registry:/var/lib/registry:Z \
    docker.io/library/registry:2

# tag
podman image tag localhost/debian:sid localhost:5000/debian:sid
# push
podman image push localhost:5000/debian:sid
# search
podman image search localhost:5000/
# pull
podman image pull localhost:5000/debian:sid

