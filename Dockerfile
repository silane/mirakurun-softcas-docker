FROM chinachu/mirakurun@sha256:0cfb0399862832ceea6db74e8397275d514dcae25e1a467be373a2ae0875deb9

RUN mkdir -p /opt/bin
RUN apt-get update

RUN apt-get install -y --no-install-recommends git cmake
RUN cd /tmp && git clone https://github.com/stz2012/libarib25.git \
 && git -C libarib25 checkout 93ff3afd0a13f42724b20564873066f470825e78
RUN cd /tmp/libarib25 && cmake . && make && make install

RUN apt-get install -y --no-install-recommends git autoconf automake
RUN cd /tmp && git clone https://github.com/stz2012/recpt1.git \
 && git -C recpt1 checkout 77c7bce2527e1df45cc8667ede753d09de7b3e6c
RUN cd /tmp/recpt1/recpt1 && ./autogen.sh && ./configure --prefix /opt --enable-b25 && make && make install

RUN apt-get install -y --no-install-recommends autoconf automake cmake libtool libpcsclite-dev
RUN cd /tmp && git clone https://github.com/tsunoda14/libyakisoba.git \
 && git -C libyakisoba checkout 03849e66ecb8e89fcdd0862eebcf43255d63794a
RUN cd /tmp/libyakisoba && autoreconf -i && mkdir build && cd build && ../configure --sysconfdir /usr/local/etc && make && make install

RUN cd /tmp && git clone https://github.com/tsunoda14/libsobacas.git \
 && git -C libsobacas checkout 77dbb010226d4959f81fc605b588836581dce038
RUN cd /tmp/libsobacas && autoreconf -i && mkdir build && cd build && ../configure && make && make install

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./recpt1_softcas.sh /opt/bin/recpt1_softcas.sh
