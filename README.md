# apk-anywhere

All you need to run Alpine's `apk` from any Docker image.

## Examples

Install alpine packages in Ubuntu:

```Dockerfile
FROM ubuntu:22.04
COPY --from=jorgeprendes420/apk-anywhere / /
RUN apk add libseccomp-static
# Now you can use /apk/usr/lib/libseccomp.a
```

Install alpine packages in a `cross-rs` image:

```Dockerfile
ARG CROSS_BASE_IMAGE
FROM $CROSS_BASE_IMAGE

COPY --from=jorgeprendes420/apk-anywhere / /
ENV MARCH=${CROSS_CMAKE_SYSTEM_PROCESSOR}
RUN apk-init ${MARCH} ${CROSS_SYSROOT} && \
    apk-${MARCH} add libseccomp-static libseccomp-dev

# tell `libsecccomp-rs` to use static linking
ENV LIBSECCOMP_LINK_TYPE="static"
ENV LIBSECCOMP_LIB_PATH="${CROSS_SYSROOT}/lib"

RUN apt-get -y update
RUN apt-get install -y pkg-config
```
