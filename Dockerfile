FROM debian:sid-slim

ARG V2RAY_VERSION=v1.3.1

COPY conf/ /conf
COPY entrypoint.sh /entrypoint.sh

RUN set -eux \
    && apt update -y \
    && apt autoremove -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y wget qrencode shadowsocks-libev nginx-light jq \
    && apt clean -y \
    && chmod +x /entrypoint.sh \
    && mkdir -p /etc/shadowsocks-libev /v2raybin /wwwroot \
    && wget -O- "https://github.com/shadowsocks/v2ray-plugin/releases/download/${V2RAY_VERSION}/v2ray-plugin-linux-amd64-${V2RAY_VERSION}.tar.gz" | \
        tar zx -C /v2raybin \
    && install /v2raybin/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -rf /v2raybin \
    && rm -rf /var/lib/apt/lists/*

CMD /entrypoint.sh
