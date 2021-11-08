FROM ubuntu:18.04

ARG firefox_version="88.0.1"

RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lob/apt/lists/*
    
## Installing Firefox 88.0.1
RUN apt-get purge firefox \
    && apt-get purge firefox \
    && apt-get install libgtk-3-0 -y \
    && apt-get install libx11-xcb1 -y \
    && apt-get install libdbus-glib-1-2 -y \
    && apt-get install libxt6 -y \
    && wget http://ftp.mozilla.org/pub/firefox/releases/${firefox_version}/linux-$(uname -m)/en-US/firefox-${firefox_version}.tar.bz2 \
    && tar xvf firefox-${firefox_version}.tar.bz2 \
    && mv firefox /opt/ \
    && ln -s /opt/firefox/firefox /usr/bin/firefox

CMD ["bash"]