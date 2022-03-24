FROM debian:sid-slim as downloader

ARG V2RAY_VERSION=v1.3.1
ADD https://github.com/shadowsocks/v2ray-plugin/releases/download/${V2RAY_VERSION}/v2ray-plugin-linux-amd64-${V2RAY_VERSION}.tar.gz /
RUN tar xzvf v2ray-plugin-linux-amd64-${V2RAY_VERSION}.tar.gz 

FROM debian:sid-slim

COPY --chmod=755 *.sh /
COPY --chmod=755 --from=downloader /v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin

RUN set -eux \
    && apt update -y \
    && apt autoremove -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y qrencode shadowsocks-libev nginx-light \
    && apt clean -y \
    && mkdir -p /etc/shadowsocks-libev /wwwroot \
    && rm -rf /var/lib/apt/lists/*

CMD /entrypoint.sh
