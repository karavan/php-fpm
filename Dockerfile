FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Karavan <admin@local.lo>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
COPY docker_opts.sh /services/docker_opts.sh
# Install required system packages and dependencies
RUN install_packages argon2 ca-certificates curl gzip libargon2-0 libargon2-0-dev \
libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 \
libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 \
libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo \
libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 \
libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 \
libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpcre3 \
libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 \
libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 \
libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 \
procps tar wget zlib1g php-mongodb dh-php php-pear php-cli php-common php-curl php-dev \
php-fpm php-gd php-json php-readline pkg-php-tools && \
apt-get clean all

RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

EXPOSE 9000

WORKDIR /app
CMD [ "php-fpm7.3", "-F", "--pid", "/run/php-fpm.pid", "-y", "/etc/php/7.3/fpm/php-fpm.conf" ]
