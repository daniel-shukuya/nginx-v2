FROM registry.access.redhat.com/ubi8/nginx-118

USER 0
# RUN yum -y install nginx-mod-http-image-filter.x86_64
RUN INSTALL_PKGS="nginx-mod-http-image-filter.x86_64" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

USER 1001

# Add application sources
# nginx.conf es copiado via configMap
ADD nginx/nginx.conf "${NGINX_CONF_PATH}"
ADD nginx/nginx-default-cfg/*.conf "${NGINX_DEFAULT_CONF_PATH}"
ADD nginx/nginx-cfg/*.conf "${NGINX_CONFIGURATION_PATH}"
# ADD nginx/index.html /usr/share/nginx/html/webposter/index.html
# ADD nginx/favicon.ico .

RUN mkdir -p /tmp/nginx/cache/amzn
# si se agrega un nuevo proveedor de VODs, crear la carpeta
#RUN mkdir -p /tmp/nginx/cache/{proveedor}

RUN chgrp -R 0 /tmp/nginx/cache && chmod -R g=u /tmp/nginx/cache

# Run script uses standard ways to run the application
CMD nginx -g "daemon off;"
