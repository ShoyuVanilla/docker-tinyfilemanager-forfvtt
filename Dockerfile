FROM php:alpine3.13

COPY php.ini $PHP_INI_DIR/php.ini

RUN apk --update add git less openssh && \
    mkdir /app && \
    cd /app && \
    git clone --branch master \
        https://github.com/ShoyuVanilla/tinyfilemanager.git \
        --depth=1 && \
    sed -i.bak -e "s/\$root\_path = \$\_SERVER\['DOCUMENT_ROOT'\];/\$root_path = \'\/data\';/g" \
        /app/tinyfilemanager/tinyfilemanager.php && \
    apk del git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

RUN apk --update add zip libzip-dev && \
    docker-php-ext-install zip fileinfo

WORKDIR /app/tinyfilemanager

ENTRYPOINT ["php"]
CMD ["-S", "0.0.0.0:80", "tinyfilemanager.php"]
