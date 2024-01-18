ARG NAME=fedora-toolbox
ARG VERSION=39
FROM fedora:${VERSION} as build
ARG DNF_OPTS="--installroot=/target --setopt=install_weak_deps=False --releasever 39"

COPY build_tools /build_tools
COPY neutrino_build_dep /neutrino_build_dep
COPY extra-packages /extra_packages
COPY toolkits /toolkits
COPY packaging_tools /packaging_tools

# prepare base system
RUN dnf $DNF_OPTS install -y fedora-release glibc glibc-langpack-en iputils less bash ncurses passwd \
                        sudo util-linux dnf glibc-all-langpacks
COPY pythia6.repo /target/etc/yum.repos.d/pythia6.repo
RUN sed -i '/enabled=1/a exclude=root root-\*' \
        /target/etc/yum.repos.d/fedora.repo \
        /target/etc/yum.repos.d/fedora-updates.repo 
RUN dnf ${DNF_OPTS} install -y $(</build_tools) \
                                $(</neutrino_build_dep) \
                                $(</extra_packages) \
                                $(</toolkits) \
                                $(</packaging_tools)
RUN dnf $DNF_OPTS clean all
RUN ln -s /usr/bin/flatpak-xdg-open /target/usr/bin/xdg-open 
RUN ln -s /usr/bin/flatpak-xdg-email /target/usr/bin/xdg-email 
COPY CC_IN2P3_FR /target/etc/krb5.conf.d/CC_IN2P3_FR


From scratch
LABEL com.github.containers.toolbox="true"
COPY --from=build /target/ /
ENV ROOTSYS=/usr

