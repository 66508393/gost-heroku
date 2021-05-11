FROM alpine:3.6

ENV VER=2.11.1 METHOD=chacha20 PASSWORD=ss123456
ENV TLS_PORT=4433 PORT=8080

RUN apk add --no-cache curl \
  && curl -sL https://github.com/xiaokaixuan/gost-heroku/releases/download/v${VER}/gost_${VER}_linux_amd64.tar.gz | tar zx \
  && mv gost_${VER}_linux_amd64 gost && chmod a+x gost/gost

WORKDIR /gost
EXPOSE ${TLS_PORT} $PORT

## CMD exec /gost/gost -L=ss+mwss://$METHOD:$PASSWORD@:$TLS_PORT -L=ss+mws://$METHOD:$PASSWORD@:$PORT

CMD exec TMPSTR=`ping home.timng.biz -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
CMD exec kk=${TMPSTR}
CMD exec nohup  /root/gost -L rtcp://:5389/127.0.0.1:5389 -F kcp://${kk}:6666?tcp=true  >udp2raw.log 2>&1 &
CMD exec nohup /root/gost -L socks5://:5389  >udp2raw.log 2>&1 &
