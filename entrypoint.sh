#!/bin/bash

if [[ -z "${PASSWORD}" ]]; then
  export PASSWORD="5c301bb8-6c77-41a0-a606-4ba11bbab084"
fi
echo ${PASSWORD}

export PASSWORD_JSON="\"$PASSWORD\""

if [[ -z "${ENCRYPT}" ]]; then
  export ENCRYPT="chacha20-ietf-poly1305"
fi

if [[ -z "${V2_Path}" ]]; then
  export V2_Path="s233"
fi
echo ${V2_Path}

if [[ -z "${QR_Path}" ]]; then
  export QR_Path="/qr_img"
fi
echo ${QR_Path}

case "$AppName" in
	*.*)
		export DOMAIN="$AppName"
		;;
	*)
		export DOMAIN="$AppName.herokuapp.com"
		;;
esac

/shadowsocks-libev_conf_gen.sh > /etc/shadowsocks-libev/config.json
echo /etc/shadowsocks-libev/config.json
cat $_

/nginx_ss_conf_gen.sh > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat $_

if [ "$AppName" = "no" ]; then
  echo "Do not generate QR-code"
else
  [ ! -d /wwwroot/${QR_Path} ] && mkdir /wwwroot/${QR_Path}
  plugin=$(echo -n "v2ray;path=/${V2_Path};host=${DOMAIN};tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')
  ss="ss://$(echo -n ${ENCRYPT}:${PASSWORD} | base64 -w 0)@${DOMAIN}:443?plugin=${plugin}" 
  echo "${ss}" | tr -d '\n' > /wwwroot/${QR_Path}/index.html
  echo -n "${ss}" | qrencode -s 6 -o /wwwroot/${QR_Path}/vpn.png
fi

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'
