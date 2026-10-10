FROM chinachu/mirakurun@sha256:0cfb0399862832ceea6db74e8397275d514dcae25e1a467be373a2ae0875deb9

RUN mkdir -p /opt/bin
RUN apt-get update

RUN apt-get install -y --no-install-recommends git cmake
RUN cd /tmp && git clone https://github.com/stz2012/libarib25.git \
 && git -C libarib25 checkout 93ff3afd0a13f42724b20564873066f470825e78 \
 && cd libarib25 && cmake . && make && make install \
 && rm -rf /tmp/libarib25

RUN apt-get install -y --no-install-recommends git autoconf automake
RUN cd /tmp && git clone https://github.com/stz2012/recpt1.git \
 && git -C recpt1 checkout 77c7bce2527e1df45cc8667ede753d09de7b3e6c \
 && cd recpt1/recpt1 && ./autogen.sh && ./configure --prefix /opt --enable-b25 && make && make install \
 && rm -rf /tmp/recpt1

RUN apt-get install -y --no-install-recommends autoconf automake cmake libtool libpcsclite-dev
RUN cd /tmp && git clone https://github.com/tsunoda14/libyakisoba.git \
 && git -C libyakisoba checkout 03849e66ecb8e89fcdd0862eebcf43255d63794a \
 && cd libyakisoba && autoreconf -i && mkdir build && cd build && ../configure --sysconfdir /usr/local/etc && make && make install \
 && rm -rf /tmp/libyakisoba

RUN cd /tmp && git clone https://github.com/tsunoda14/libsobacas.git \
 && git -C libsobacas checkout 77dbb010226d4959f81fc605b588836581dce038 \
 && cd libsobacas && autoreconf -i && mkdir build && cd build && ../configure && make && make install \
 && rm -rf /tmp/libsobacas

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 <<'EOF' /opt/bin/recpt1_softcas.sh
#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=/usr/local/lib/libsobacas.so
exec /opt/bin/recpt1 "$@"
EOF
