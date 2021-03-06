# -----------------------
# Stage 1 - Build Jamulus
# -----------------------
FROM alpine:3.13 as builder
RUN echo "--------- Stage 1 - Build Jamulus --------------"

ENV JAMULUS_VERSION 3_6_2

RUN \
 echo "**** updating system packages ****" && \
 apk update

RUN \
 echo "**** install build packages ****" && \
   apk add --no-cache --virtual .build-dependencies \
        build-base \
        wget \
        qt5-qtbase-dev \
        qt5-qttools-dev \
        qtchooser

WORKDIR /tmp
RUN \
 echo "**** getting source code ****" && \
   wget "https://github.com/corrados/jamulus/archive/r${JAMULUS_VERSION}.tar.gz" && \
   tar xzf r${JAMULUS_VERSION}.tar.gz

# Github directory format for tar.gz export
WORKDIR /tmp/jamulus-r${JAMULUS_VERSION}
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound headless" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

# -----------------------
# Stage 2 - Production
# -----------------------
RUN echo "---------  Stage 2 - Production --------------"
FROM alpine:3.13 

# More information
RUN apk add --update --no-cache \
    qt5-qtbase-x11 icu-libs tzdata 
    

RUN adduser --system --no-create-home jamulus

RUN echo "---------  Copy files --------------"
COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus
COPY ./jamulus.service /etc/systemd/system/jamulus.service
RUN ls

RUN echo "---------  Setup service --------------"
USER root
RUN chmod 644 /etc/systemd/system/jamulus.service
# RUN systemctl enable jamulus (does not work in alpine)
RUN rc-update add jamulus boot
RUN rc-status --list

USER jamulus

# ENTRYPOINT ["Jamulus"]
# ADD expose
EXPOSE 22124/udp

