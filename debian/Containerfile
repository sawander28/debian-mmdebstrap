# build a Debian image using the cross-build support in mmdebstrap

FROM --platform=$BUILDPLATFORM containers.torproject.org/tpo/tpa/base-images/debian:trixie AS builder

ARG SUITE

ARG COMPONENTS="main"

ARG ADD_MIRROR=""

ARG TARGETARCH

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -Uqq --no-install-recommends install arch-test gpg mmdebstrap

COPY minimize-config ./minimize-config

RUN mmdebstrap \
    --mode=root \
    --variant=minbase \
    --components="${COMPONENTS}" \
    --architectures="${TARGETARCH}" \
    --include='ca-certificates' \
    --aptopt='Acquire::Languages "none"' \
    --dpkgopt='path-exclude=/usr/share/man/*' \
    --dpkgopt='path-exclude=/usr/share/man/man[1-9]/*' \
    --dpkgopt='path-exclude=/usr/share/locale/*' \
    --dpkgopt='path-include=/usr/share/locale/locale.alias' \
    --dpkgopt='path-exclude=/usr/share/lintian/overrides/*' \
    --dpkgopt='path-exclude=/usr/share/info/*' \
    --dpkgopt='path-exclude=/usr/share/doc/*' \
    --dpkgopt='path-include=/usr/share/doc/*/copyright' \
    --dpkgopt='path-exclude=/usr/share/omf/*' \
    --dpkgopt='path-exclude=/usr/share/help/*' \
    --dpkgopt='path-exclude=/usr/share/gnome/*' \
    --dpkgopt='path-exclude=/usr/share/examples/*' \
    --setup-hook='cp minimize-config/dpkg.cfg.d/* "$1/etc/dpkg/dpkg.cfg.d/"' \
    --setup-hook='cp minimize-config/apt.conf.d/* "$1/etc/apt/apt.conf.d/"' \
    --customize-hook='find "$1"/usr/share/doc -type f -exec gzip -9 {} \;' \
    --customize-hook='find "$1"/usr/share/doc -type d -empty -delete' \
    --customize-hook='rm "$1"/etc/resolv.conf' \
    --customize-hook='rm "$1"/etc/hostname' \
    --customize-hook='rm "$1"/var/cache/debconf/*.dat-old' \
    --customize-hook='rm "$1"/var/lib/dpkg/*-old' \
    --customize-hook='cd "$1"/usr/share/man && mkdir -p man1 man2 man3 man4 man5 man6 man7 man8' \
    ${ADD_MIRROR:+--setup-hook='echo "'"$ADD_MIRROR"'" >  "$1"/etc/apt/sources.list.d/custom.list'} \
    --skip=chroot/mount \
    --verbose \
    "$SUITE" /tmp/rootfs.tar

FROM --platform=$BUILDPLATFORM containers.torproject.org/tpo/tpa/base-images/debian:trixie AS decompressor

COPY --from=builder /tmp/rootfs.tar /tmp

RUN mkdir /tmp/rootfs && \
    cd /tmp/rootfs && \
    tar --exclude="./dev/*" -xf ../rootfs.tar

FROM scratch

COPY --from=decompressor /tmp/rootfs /

# remove date of last password change from all /etc/shadow entries
RUN for u in $(awk -F':' '{ print $1}' /etc/passwd); do \
    chage --lastday -1 $u; \
    done; \
    rm -f /etc/shadow-

CMD [ "bash" ]
