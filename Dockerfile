ARG NAME=fedora-toolbox
ARG VERSION=39
FROM registry.fedoraproject.org/fedora-toolbox:$VERSION
LABEL com.github.containers.toolbox="true" \
      com.redhat.component="$NAME" \
      name="$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Modified version of fedora toolbox for personal daily use" \
      maintainer="Qiyu Yan <yanqiyu01@gmail.com>"

COPY to_be_installed /to_be_installed

# install packages from to_be_installed
RUN dnf update -y && \
    dnf install -y $(</to_be_installed) && \
    dnf clean all && \
    ln -s /usr/bin/flatpak-xdg-open /usr/bin/xdg-open && \
    ln -s /usr/bin/flatpak-xdg-email /usr/bin/xdg-email && \
    rm /to_be_installed

# krb5 configuration for cc.in2p3.fr
COPY CC_IN2P3_FR /etc/krb5.conf.d/CC_IN2P3_FR

