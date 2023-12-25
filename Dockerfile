FROM redhat/ubi8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
RUN dnf -y install wget git maven sudo && \
    dnf clean all && \
    rm -rf /var/cache/yum && \
    groupadd -g 991 storm && \
    adduser --uid 991 --gid 991 -m storm && \
    usermod -aG wheel storm && \
    mkdir -p /var/log/storm/webdav && \
    mkdir -p /var/lib/storm-webdav/work && \
    mkdir -p /etc/grid-security/storm-webdav && \
    mkdir -p /etc/grid-security/vomsdir && \
    echo 'storm ALL=(ALL) NOPASSWD: /usr/bin/update-ca-trust' \
    > /etc/sudoers.d/trust && \
    git clone https://github.com/italiangrid/storm-webdav.git && \
    cd storm-webdav && \
    mkdir -p ~/.m2 && \
    cp cnaf-mirror-settings.xml ~/.m2/settings.xml && \
    git checkout tags/v1.4.1 && \
    sed -i '45,93 s/@Validated/\/*@Validated*\//' \
    ./src/main/java/org/italiangrid/storm/webdav/config/ServiceConfigurationProperties.java && \
    mvn -Pnexus package && \
    cd .. && \
    rm -rf ~/.m2 && \
    tar xzvf storm-webdav/target/storm-webdav-server.tar.gz && \
    rm -rf storm-webdav && \
    mv /usr/share/java/storm-webdav/storm-webdav-server.jar \
    /etc/storm/webdav/storm-webdav-server.jar && \
    chown storm:storm -R /etc/grid-security/storm-webdav && \
    chown storm:storm -R /var/log/storm && \
    chown storm:storm -R /var/lib/storm-webdav && \
    chown storm:storm -R /etc/storm
USER storm
WORKDIR /etc/storm/webdav
