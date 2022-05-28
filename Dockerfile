FROM alpine:3.16

ENV XRAY_PLUGIN_VERSION v1.5.5
ENV SHADOWSOCKS_VERSION v1.14.3

COPY conf/ /conf
COPY entrypoint.sh /entrypoint.sh

RUN set -ex\
    && apk add --no-cache libqrencode wget nginx jq \
    && chmod +x /entrypoint.sh \
    && mkdir -p /etc/shadowsocks-libev /wwwroot \
    && wget -O /root/xray-plugin.tar.gz https://github.com/teddysun/xray-plugin/releases/download/${XRAY_PLUGIN_VERSION}/xray-plugin-linux-amd64-${XRAY_PLUGIN_VERSION}.tar.gz \
    && tar xvzf /root/xray-plugin.tar.gz -C /root \
    && mv /root/xray-plugin_linux_amd64 /usr/local/bin/xray-plugin \
    && rm -f /root/xray-plugin.tar.gz \
    && wget -O /root/shadowsocks-plugin.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SHADOWSOCKS_VERSION}/shadowsocks-${SHADOWSOCKS_VERSION}.x86_64-unknown-linux-musl.tar.xz \
    && tar xvf /root/shadowsocks-plugin.tar.xz -C /root \
    && mv /root/ss* /usr/local/bin/ \
    && rm -f /root/shadowsocks-plugin.tar.xz \
    && apk del wget

CMD /entrypoint.sh
