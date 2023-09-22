FROM alpine:3.18 as base

RUN cat <<'EOF' > /usr/local/bin/apk && chmod a+x /usr/local/bin/apk
#!/bin/sh
LD_LIBRARY_PATH="/alpine/lib/:$LD_LIBRARY_PATH" /alpine/lib/ld-musl-x86_64.so.1 -- /alpine/sbin/apk "$@"
EOF

RUN cat <<'EOF' > /usr/local/bin/apk-init && chmod a+x /usr/local/bin/apk-init
#!/bin/sh
mkdir -p "/apk-$1/etc/apk"
mkdir -p "/apk-$1/etc/apk/keys"
mkdir -p "/apk-$1/etc/apk/protected_paths.d"
echo "$1" > "/apk-$1/etc/apk/arch"
cp /alpine/etc/apk/repositories "/apk-$1/etc/apk/"
apk add --no-cache --initdb -p "/apk-$1" --allow-untrusted alpine-keys
cat <<EOT > "/usr/local/bin/apk-$1" && chmod a+x "/usr/local/bin/apk-$1"
#!/bin/sh
apk --root "/apk-$1" "\$@"
EOT
EOF

FROM scratch

COPY --from=base /sbin/apk                /alpine/sbin/apk
COPY --from=base /lib/libcrypto.so.3      /alpine/lib/libcrypto.so.3
COPY --from=base /lib/libz.so.1           /alpine/lib/libz.so.1
COPY --from=base /lib/libapk.so.2.14.0    /alpine/lib/libapk.so.2.14.0
COPY --from=base /lib/ld-musl-x86_64.so.1 /alpine/lib/ld-musl-x86_64.so.1
COPY --from=base /lib/libssl.so.3         /alpine/lib/libssl.so.3
COPY --from=base /etc/apk/repositories    /alpine/etc/apk/repositories
COPY --from=base /etc/ssl                 /etc/ssl
COPY --from=base /usr/local/bin/apk       /usr/local/bin/apk
COPY --from=base /usr/local/bin/apk-init  /usr/local/bin/apk-init