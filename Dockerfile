ARG NAME=fedora-toolbox
ARG VERSION=39
FROM fedora:${VERSION} as build
ARG DNF_OPTS="--installroot=/target --setopt=install_weak_deps=False --releasever 39"

COPY to_be_installed /to_be_installed
COPY genie_build_dep /genie_build_dep
COPY extra-packages /extra_packages

# install packages from to_be_installed
RUN dnf install $DNF_OPTS -y fedora-release glibc glibc-langpack-en iputils less bash ncurses passwd \
                             sudo util-linux dnf $(</extra_packages)
RUN dnf install -y 'dnf-command(copr)'
RUN dnf $DNF_OPTS copr enable -y yanqiyu/pythia6 
RUN sed -i '/enabled=1/a exclude=root root-\*' \
        /target/etc/yum.repos.d/fedora.repo \
        /target/etc/yum.repos.d/fedora-updates.repo 
RUN dnf install ${DNF_OPTS} -y $(</to_be_installed) $(</genie_build_dep)
RUN dnf $DNF_OPTS clean all
RUN ln -s /usr/bin/flatpak-xdg-open /target/usr/bin/xdg-open 
RUN ln -s /usr/bin/flatpak-xdg-email /target/usr/bin/xdg-email 
COPY CC_IN2P3_FR /target/etc/krb5.conf.d/CC_IN2P3_FR


From scratch
LABEL com.github.containers.toolbox="true"
COPY --from=build /target/ /
ENV ROOTSYS=/usr

