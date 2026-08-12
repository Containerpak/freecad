FROM ubuntu:26.04 AS source

ADD --checksum=sha256:3a853eb69ee595f779f2255dbf80a765926981d8ff68903cefee4dfb03a8f5ef \
    https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/FreeCAD_1.1.3-Linux-x86_64-py311.AppImage \
    /tmp/FreeCAD.AppImage

RUN chmod 0755 /tmp/FreeCAD.AppImage && \
    /tmp/FreeCAD.AppImage --appimage-extract

FROM ghcr.io/containerpak/mesa:main

COPY --from=source /squashfs-root /opt/freecad

RUN printf '#!/bin/sh\nexec /opt/freecad/AppRun "$@"\n' > /usr/bin/freecad && \
    chmod 0755 /usr/bin/freecad && \
    cpak-clean-junk
