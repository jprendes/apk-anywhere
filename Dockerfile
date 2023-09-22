FROM alpine:3.18 as base

FROM scratch as apk-anywhere

COPY --from=base /sbin/apk                /alpine/sbin/apk
COPY --from=base /lib/libcrypto.so.3      /alpine/lib/libcrypto.so.3
COPY --from=base /lib/libz.so.1           /alpine/lib/libz.so.1
COPY --from=base /lib/libapk.so.2.14.0    /alpine/lib/libapk.so.2.14.0
COPY --from=base /lib/ld-musl-*           /alpine/lib/
COPY --from=base /lib/libssl.so.3         /alpine/lib/libssl.so.3
COPY --from=base /etc/apk/repositories    /alpine/etc/apk/repositories
COPY --from=base /etc/ssl                 /etc/ssl

COPY ./apk       /usr/local/bin/apk
COPY ./apk-init  /usr/local/bin/apk-init