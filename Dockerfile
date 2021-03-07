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
FROM alpine:latest

# More information
RUN apk update \
    && apk add  openrc --no-cache 
#    "/usr/local/sbin/rc-update" add jamulus

RUN apk add --update --no-cache \
    qt5-qtbase-x11 icu-libs tzdata 

RUN echo "---------  Copy files --------------"
COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus
COPY ./jamulus /etc/init.d/jamulus

RUN echo "---------  Setup service --------------"
RUN chmod 755 /etc/init.d/jamulus
RUN chown root:root /etc/init.d/jamulus
RUN echo $PATH
RUN rc-update add jamulus boot
RUN rc-status --list
CMD Jamulus --nogui --server --norecord --numchannels 5
# https://jamulus.io/de/wiki/Command-Line-Options

#RUN adduser --system --no-create-home jamulus
#USER jamulus

# ENTRYPOINT ["Jamulus"]
# ADD expose
EXPOSE 22124/udp

