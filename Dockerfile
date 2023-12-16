ARG NAME=fedora-toolbox
ARG VERSION=39
FROM registry.fedoraproject.org/fedora-toolbox:$VERSION
LABEL com.github.containers.toolbox="true" \
      com.redhat.component="$NAME" \
      name="$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Modified version of fedora toolbox" \
      maintainer="Debarshi Ray <rishi@fedoraproject.org>"
      
# install packages from to_be_installed
RUN dnf update -y && \
    dnf install -y $(<to_be_installed) && \
    dnf clean all

# krb5 configuration for cc.in2p3.fr
COPY CC_IN2P3_FR /etc/krb5.conf.d/CC_IN2P3_FR

