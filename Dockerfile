FROM nginx:alpine

ENV v2VER=4.20.0

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod -R g+rwx /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html \
 && chgrp -R root /var/cache/nginx \
 && sed -i 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf \
 && sed -i 's/^user/#user/' /etc/nginx/nginx.conf \
 && mkdir -m 777 /v2raybin \
 && cd /v2raybin \
 && curl -L -H "Cache-Control: no-cache" -o v2rayf.zip https://github.com/v2ray/v2ray-core/releases/download/v${v2VER}/v2ray-linux-64.zip \
 && unzip v2rayf.zip \
 && chmod +x /v2raybin/v2ray /v2raybin/v2ctl \
 && rm -rf v2rayf.zip v2ray.sig v2ctl.sig doc vpoint_socks_vmess.json systemv systemd vpoint_vmess_freedom.json geoip.dat geosite.dat \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin

COPY v2conf /v2raybin
COPY www /usr/share/nginx/html

RUN chmod +x /v2raybin/config.json /v2raybin/run.sh

# RUN addgroup nginx root
# USER nginx

ENTRYPOINT /v2raybin/run.sh

EXPOSE 8080 8081
