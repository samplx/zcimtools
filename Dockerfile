#
#	Copyright 2024, 2025 James Burlingame
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	    http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#

# cSpell:disable
# ----------------------------------------------------------------------------
ARG OS_VERSION=12.10
FROM debian:${OS_VERSION} AS base

# first create a base image that includes bash, etc. and our user

# name of the user than owns the tools
ARG TOOL_USER=zcimtools
ENV TOOL_USER=${TOOL_USER}

# where the tools get built
ARG BUILD_DIR=/build
ENV BUILD_DIR=${BUILD_DIR}

# where the Amsterdam Compiler Kit gets installed
ARG ACK_TARGET_DIR=/opt/ack
ENV ACK_TARGET_DIR=${ACK_TARGET_DIR}

# where the SimH emulators get installed
ARG SIMH_TARGET_DIR=/opt/simh
ENV SIMH_TARGET_DIR=${SIMH_TARGET_DIR}

# default link for which SimH to use: altair, classic, opensimh
ARG DEFAULT_SIMH=opensimh
ENV DEFAULT_SIMH=${DEFAULT_SIMH}

# where the Original YAZE emulator gets installed
ARG YAZE_TARGET_DIR=/opt/yaze
ENV YAZE_TARGET_DIR=${YAZE_TARGET_DIR}

# where the YAZE-AG emulator gets installed
ARG YAZE_AG_TARGET_DIR=/opt/yaze-ag
ENV YAZE_AG_TARGET_DIR=${YAZE_AG_TARGET_DIR}

# where z80pack and associated tools gets installed
ARG Z80PACK_TARGET_DIR=/opt/z80pack
ENV Z80PACK_TARGET_DIR=${Z80PACK_TARGET_DIR}

# where misc tools get installed
ARG ZCIMTOOLS_TARGET_DIR=/opt/zcimtools
ENV ZCIMTOOLS_TARGET_DIR=${ZCIMTOOLS_TARGET_DIR}

# where all the z88dk stuff goes
ARG Z88DK_TARGET_DIR=/opt/z88dk
ENV Z88DK_TARGET_DIR=${Z88DK_TARGET_DIR}


# minimal local since it is all ASCII, right?
ENV LANG C.UTF-8

# base system includes a fair number of tools for interactive use.
# but no compilers to force use of a builder layer for that.
RUN groupadd --gid 1000 ${TOOL_USER} \
    && useradd --uid 1000 --gid ${TOOL_USER} --shell /bin/bash --create-home ${TOOL_USER} \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        bash \
        ca-certificates \
        cpmtools \
        curl \
        dos2unix \
        file \
        fonts-dejavu \
        git \
        jq \
        less \
        libdsk4 \
        libdsk-utils \
        libgfortran5 \
        libglu1-mesa \
        libgmp10 \
        libpcap0.8 \
        libpcre3 \
        libpng16-16 \
        libreadline8 \
        libsdl2-2.0-0 \
        libsdl2-ttf-2.0-0 \
        libvdeplug2 \
        libvdeplug-pcap \
        libxml2 \
        make \
        man-db \
        manpages \
        manpages-dev \
        pkg-config \
        procps \
        psmisc \
        unzip \
        vim \
        wget \
    && mkdir -p \
        ${ACK_TARGET_DIR} \
        ${SIMH_TARGET_DIR} \
        ${YAZE_TARGET_DIR} \
        ${YAZE_AG_TARGET_DIR} \
        ${Z80PACK_TARGET_DIR} \
        ${Z88DK_TARGET_DIR} \
        ${ZCIMTOOLS_TARGET_DIR}/lib \
    && chown --recursive --changes ${TOOL_USER} \
        ${ACK_TARGET_DIR} \
        ${SIMH_TARGET_DIR} \
        ${YAZE_TARGET_DIR} \
        ${YAZE_AG_TARGET_DIR} \
        ${Z80PACK_TARGET_DIR} \
        ${Z88DK_TARGET_DIR} \
        ${ZCIMTOOLS_TARGET_DIR} \
    && echo "${ZCIMTOOLS_TARGET_DIR}/lib" > /etc/ld.so.conf.d/zcimtools.conf \
    && ldconfig

ENV PATH="${ACK_TARGET_DIR}/bin:${SIMH_TARGET_DIR}/default/bin:${SIMH_TARGET_DIR}/bin:${Z80PACK_TARGET_DIR}/bin:${ZCIMTOOLS_TARGET_DIR}/bin:${Z88DK_TARGET_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV ZCCCFG=${Z88DK_TARGET_DIR}/lib/config

COPY --chown=${TOOL_USER}:${TOOL_USER} src/vimrc /home/zcimtools/.vimrc

# ----------------------------------------------------------------------------
FROM base AS builder

RUN mkdir -p ${BUILD_DIR} \
    && chown --recursive --changes ${TOOL_USER} ${BUILD_DIR} \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        bison \
        build-essential \
        ccache \
        cmake \
        cpanminus \
        flex \
        gcc-12 \
        gdb \
        gfortran \
        git-svn \
        libcapture-tiny-perl \
        libclone-perl \
        libdata-hexdump-perl \
        libfile-slurp-perl \
        libglu1-mesa-dev \
        libgmp3-dev \
        libjpeg-dev \
        liblocal-lib-perl \
        libmodern-perl-perl \
        libpath-tiny-perl \
        libpcap0.8-dev \
        libpcre3-dev \
        libpng-dev \
        libreadline-dev \
        libregexp-common-perl \
        libsdl2-dev \
        libsdl2-ttf-dev \
        libtext-table-perl \
        libtool \
        libvdeplug-dev \
        libxml2-dev \
        libyaml-perl \
        lua5.4 \
        lynx \
        m4 \
        ninja-build \
        perl \
        ragel \
        re2c \
        subversion \
        texi2html \
        texinfo \
        zlib1g-dev \
    && cpanm \
        App::Prove \
        Capture::Tiny \
        CPU::Z80::Assembler \
        Data::Dump \
        Data::HexDump \
        File::Path \
        List::Uniq \
        Modern::Perl \
        Object::Tiny::RW \
        Path::Tiny \
        Regexp::Common \
        Template \
        Template::Plugin::YAML \
        Test::Harness \
        Test::HexDifferences \
        Text::Diff \
        Text::Table YAML::Tiny \
    && cc --version \
    && gcc --version \
    && gfortran --version \
    && perl -V

WORKDIR ${BUILD_DIR}
USER ${TOOL_USER}

COPY --chown=${TOOL_USER}:${TOOL_USER} share/ ${ZCIMTOOLS_TARGET_DIR}/share/

# ----------------------------------------------------------------------------
FROM builder AS ack
ARG ACK_REPO=https://github.com/davidgiven/ack.git
RUN git clone --depth 2 ${ACK_REPO} ack \
    && make -C ack PREFIX=${ACK_TARGET_DIR} DEFAULT_PLATFORM=cpm BUILDDIR=${BUILD_DIR}/ack-build all install

# ----------------------------------------------------------------------------
FROM builder AS simh
ARG CLASSIC_SIMH_ZIP_ARCHIVE_URL=https://simh.trailing-edge.com/sources/simhv312-5.zip
ARG CLASSIC_SIMH_ZIP_ARCHIVE=simhv312-5.zip
ARG OPENSIMH_SIMH_REPO=https://github.com/open-simh/simh.git
ARG OPENSIMH_SIMTOOLS_REPO=https://github.com/open-simh/simtools.git

RUN mkdir -p \
        ${SIMH_TARGET_DIR}/bin \
        ${SIMH_TARGET_DIR}/classic/bin \
        ${SIMH_TARGET_DIR}/opensimh/bin \
    && wget --quiet --unlink ${CLASSIC_SIMH_ZIP_ARCHIVE_URL} \
    && unzip ${CLASSIC_SIMH_ZIP_ARCHIVE} \
    && make -C sim \
    && rm -rf sim/BIN/buildtools \
    && cp sim/BIN/* ${SIMH_TARGET_DIR}/classic/bin \
    && git clone --depth 2 ${OPENSIMH_SIMH_REPO} opensimh \
    && mkdir -p opensimh/cmake/build-ninja \
    && cd opensimh/cmake/build-ninja \
    && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -S ../.. -B . --install-prefix ${SIMH_TARGET_DIR}/opensimh \
    && cmake --build . \
    && cmake --install . \
    && cd ../../.. \
    && git clone --depth 2 ${OPENSIMH_SIMTOOLS_REPO} simtools \
    && make -C simtools BIN=${SIMH_TARGET_DIR}/bin all install

# ----------------------------------------------------------------------------
FROM builder AS yazeag
ARG YAZE_AG_TARBALL_URL=https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.51.3.tar.gz
ARG YAZE_AG_TARBALL=yaze-ag-2.51.3.tar.gz
ARG YAZE_AG_BUILD_DIR=yaze-ag-2.51.3

RUN mkdir -p ${YAZE_AG_TARGET_DIR}/bin ${ZCIMTOOLS_TARGET_DIR}/bin \
    && wget --quiet --unlink ${YAZE_AG_TARBALL_URL} \
    && tar xzvf ${YAZE_AG_TARBALL} \
    && make -C ${YAZE_AG_BUILD_DIR} -f Makefile_linux_64_amd_athlon64 \
        OPTIMIZE=-O3 \
        BINDIR=${YAZE_AG_TARGET_DIR}/bin \
        MANDIR=${YAZE_AG_TARGET_DIR}/man/man1 \
        LIBDIR=${YAZE_AG_TARGET_DIR}/lib \
            install \
    && rm --force ${YAZE_AG_TARGET_DIR}/bin/yaze

# ----------------------------------------------------------------------------
FROM builder AS yaze
ARG YAZE_REPO=https://github.com/lipro-cpm4l/yaze.git

RUN mkdir -p \
        ${YAZE_TARGET_DIR}/bin \
        ${YAZE_TARGET_DIR}/etc \
        ${YAZE_TARGET_DIR}/man/man1 \
        ${YAZE_TARGET_DIR}/share \
        ${ZCIMTOOLS_TARGET_DIR}/bin \
    && git clone --depth 2 ${YAZE_REPO} yaze \
    && cp -r yaze/test ${YAZE_TARGET_DIR}/share/ \
    && printf 'mount a %s/share/test\ngo\n' ${YAZE_TARGET_DIR} > ${YAZE_TARGET_DIR}/etc/yazerc \
    && make -C yaze \
        BINDIR=${ZCIMTOOLS_TARGET_DIR}/bin \
        MANDIR=${YAZE_TARGET_DIR}/man/man1 \
        LIBDIR=${YAZE_TARGET_DIR}/share \
        SYSCONFDIR=${YAZE_TARGET_DIR}/etc \
            all install

# ----------------------------------------------------------------------------
FROM builder AS z80pack
ARG Z80PACK_REPO=https://github.com/udo-munk/z80pack.git

RUN git clone --depth 2 ${Z80PACK_REPO} z80pack \
    && make -C z80pack \
          PREFIX=${Z80PACK_TARGET_DIR} \
          DATADIR=${Z80PACK_TARGET_DIR}/share \
          DOCDIR=${Z80PACK_TARGET_DIR}/doc \
    && make -C z80pack/cpmsim/srctools install PREFIX=${Z80PACK_TARGET_DIR} \
    && make -C z80pack/z80asm install PREFIX=${Z80PACK_TARGET_DIR}

# ----------------------------------------------------------------------------
FROM builder AS z88dk
ARG BOOST_LIB_TARBALL_URL=https://archives.boost.io/release/1.87.0/source/boost_1_87_0.tar.bz2
ARG BOOST_LIB_TARBALL=boost_1_87_0.tar.bz2
ARG BOOST_LIB_DIR=boost_1_87_0
ARG Z88DK_REPO=https://github.com/z88dk/z88dk.git

RUN wget --quiet --unlink ${BOOST_LIB_TARBALL_URL} \
    && tar xjf ${BOOST_LIB_TARBALL} \
    && git clone --recursive --depth 2 ${Z88DK_REPO} z88dk \
    && cd z88dk \
    && chmod 700 build.sh \
    && CPPFLAGS="-I${BUILD_DIR}/${BOOST_LIB_DIR}" BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh -i ${Z88DK_TARGET_DIR} -t -v -c

# ----------------------------------------------------------------------------
FROM builder AS zcimtools
ARG LAR_TARBALL_URL=https://www.seasip.info/Unix/Lar/lar-5.1.2.tar.gz
ARG LAR_TARBALL=lar-5.1.2.tar.gz
ARG LAR_BUILD_DIR=lar-5.1.2
ARG PASMO_TARBALL_URL=https://pasmo.speccy.org/bin/pasmo-0.5.5.tar.gz
ARG PASMO_TARBALL=pasmo-0.5.5.tar.gz
ARG PASMO_BUILD_DIR=pasmo-0.5.5
ARG THAMES_TARBALL_URL=http://www.seasip.info/Unix/Thames/thames-0.1.1.tar.gz
ARG THAMES_TARBALL=thames-0.1.1.tar.gz
ARG THAMES_BUILD_DIR=thames-0.1.1

ARG DISK_UTILITIES_REPO_URL=https://github.com/keirf/disk-utilities.git
ARG ZXCC_REPO_URL=https://github.com/agn453/ZXCC.git
ARG INTEL_HEX_LOADER_REPO_URL=https://github.com/samplx/intel-hex-loader.git
ARG RUNCPM_REPO_URL=https://github.com/MockbaTheBorg/RunCPM.git

ARG LD80_ZIP_ARCHIVE_URL=http://48k.ca/ld80.zip
ARG LD80_ZIP_ARCHIVE=ld80.zip
ARG RZ80_ZIP_ARCHIVE_URL=http://48k.ca/rz80.zip
ARG RZ80_ZIP_ARCHIVE=rz80.zip
ARG ZMAC_ZIP_ARCHIVE_URL=http://48k.ca/zmac.zip
ARG ZMAC_ZIP_ARCHIVE=zmac.zip

COPY --chown=${TOOL_USER}:${TOOL_USER} src/ src/


RUN mkdir -p ${ZCIMTOOLS_TARGET_DIR}/bin ${ZCIMTOOLS_TARGET_DIR}/libexec zmac ld80 rz80 \
    && make -C src/hexcom all check install \
    && make -C src/interp80 all check install \
    && make -C src/lbrate all install \
    && make -C src/mac80 all check install \
    && make -C src/nomarch all install \
    && make -C src/plm80-2 all check install \
    && make -C src/plm80-4 all check install \
    && make -C src/unarj all install \
    && git clone --depth 2 ${INTEL_HEX_LOADER_REPO_URL} intel-hex-loader \
    && cd intel-hex-loader \
    && autoreconf -i \
    && ./configure --prefix=/opt/zcimtools \
    && make all check install \
    && cd .. \
    && git clone --depth 2 ${RUNCPM_REPO_URL} RunCPM \
    && cd RunCPM \
    && make -C RunCPM posix rebuild \
    && rm -f ${ZCIMTOOLS_TARGET_DIR}/bin/RunCPM \
    && cp RunCPM/RunCPM ${ZCIMTOOLS_TARGET_DIR}/bin/RunCPM \
    && cd .. \
    && git clone --depth 2 ${ZXCC_REPO_URL} zxcc \
    && cd zxcc \
    && autoreconf -i \
    && ./configure --prefix=${ZCIMTOOLS_TARGET_DIR} \
    && make all install \
    && cd .. \
    && git clone --depth 2 ${DISK_UTILITIES_REPO_URL} disk-utilities \
    && make -C disk-utilities PREFIX=${ZCIMTOOLS_TARGET_DIR} all install \
    && wget --quiet --unlink ${LAR_TARBALL_URL} \
    && tar xzf ${LAR_TARBALL} \
    && cd ${LAR_BUILD_DIR} \
    && make lar \
    && cp lar lbr ${ZCIMTOOLS_TARGET_DIR}/bin \
    && cd .. \
    && wget --quiet --unlink ${PASMO_TARBALL_URL} \
    && tar xzf ${PASMO_TARBALL} \
    && cd ${PASMO_BUILD_DIR} \
    && ./configure --prefix=${ZCIMTOOLS_TARGET_DIR} \
    && make all check install \
    && cd .. \
    && wget --quiet --unlink ${THAMES_TARBALL_URL} \
    && tar xzf ${THAMES_TARBALL} \
    && cd ${THAMES_BUILD_DIR} \
    && ./configure --prefix=${ZCIMTOOLS_TARGET_DIR} \
    && make all install \
    && cd .. \
    && wget --quiet --unlink ${LD80_ZIP_ARCHIVE_URL} \
    && cd ld80 \
    && unzip ../${LD80_ZIP_ARCHIVE} \
    && make \
    && cp ld80 ${ZCIMTOOLS_TARGET_DIR}/bin \
    && cd .. \
    && wget --quiet --unlink ${RZ80_ZIP_ARCHIVE_URL} \
    && cd rz80 \
    && unzip ../${RZ80_ZIP_ARCHIVE} \
    && g++ -DUSE_FUNC -DUSE_DEFERRED_FLAGS -O3 -std=c++11 -Wno-c++11-extensions \
	    -o ${ZCIMTOOLS_TARGET_DIR}/bin/rz80 rz80.cpp -DNO_INSTRUCTION_LOG fz80.cpp refz80.cpp zi80dis.cpp loader.cpp \
    && cd .. \
    && wget --quiet --unlink ${ZMAC_ZIP_ARCHIVE_URL} \
    && cd zmac \
    && unzip ../${ZMAC_ZIP_ARCHIVE} \
    && make -C src \
    && cp src/zmac ${ZCIMTOOLS_TARGET_DIR}/bin \
    && cd .. \
    && rm -f ${ZCIMTOOLS_TARGET_DIR}/bin/yaze-ag \
    && cp src/scripts/yaze-ag.sh ${ZCIMTOOLS_TARGET_DIR}/bin/yaze-ag \
    && chmod 755 ${ZCIMTOOLS_TARGET_DIR}/bin/yaze-ag \
    && cp src/scripts/cpm-wrapper.sh ${ZCIMTOOLS_TARGET_DIR}/libexec/cpm-wrapper.sh \
    && chmod 755 ${ZCIMTOOLS_TARGET_DIR}/libexec/cpm-wrapper.sh \
    && sed -e s:@@SIMH_TARGET_DIR@@:${SIMH_TARGET_DIR}:g src/scripts/go-classic.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/go-classic \
    && sed -e s:@@SIMH_TARGET_DIR@@:${SIMH_TARGET_DIR}:g src/scripts/go-opensimh.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/go-opensimh \
    && chmod 755 ${ZCIMTOOLS_TARGET_DIR}/bin/go-classic ${ZCIMTOOLS_TARGET_DIR}/bin/go-opensimh \
    && sed -e s/@@PROGRAM_NAME@@/asm80/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-asm80 \
    && sed -e s/@@PROGRAM_NAME@@/hexobj/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-hexobj \
    && sed -e s/@@PROGRAM_NAME@@/ixref/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-ixref \
    && sed -e s/@@PROGRAM_NAME@@/lib/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-lib \
    && sed -e s/@@PROGRAM_NAME@@/link/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-link \
    && sed -e s/@@PROGRAM_NAME@@/locate/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-locate \
    && sed -e s/@@PROGRAM_NAME@@/objhex/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-objhex \
    && sed -e s/@@PROGRAM_NAME@@/plm80/ -e s/@@PROGRAM_VERSION@@/z80pack/ src/scripts/isis-wrapper.sh > ${ZCIMTOOLS_TARGET_DIR}/bin/isis-plm80 \
    && chmod 755 \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-asm80 \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-hexobj \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-ixref \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-lib \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-link \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-locate \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-objhex \
        ${ZCIMTOOLS_TARGET_DIR}/bin/isis-plm80 \
    && cd ${ZCIMTOOLS_TARGET_DIR}/share/cpm-wrapper \
    && for name in *.com; do \
        echo "$name" && \
        rm -f ${ZCIMTOOLS_TARGET_DIR}/bin/$name && \
        ln ${ZCIMTOOLS_TARGET_DIR}/libexec/cpm-wrapper.sh ${ZCIMTOOLS_TARGET_DIR}/bin/$name; \
    done


# ----------------------------------------------------------------------------
FROM base AS final
RUN mkdir -p ${BUILD_DIR} /work \
    && rm --recursive --force /var/lib/apt/lists/* \
    && cd ${SIMH_TARGET_DIR} \
    && rm -f default \
    && ln -s ${DEFAULT_SIMH} default \
    && chown --recursive --changes ${TOOL_USER} ${BUILD_DIR} /opt \
    && ldconfig

WORKDIR ${BUILD_DIR}
USER ${TOOL_USER}

COPY --from=ack ${ACK_TARGET_DIR} ${ACK_TARGET_DIR}

COPY --from=simh ${SIMH_TARGET_DIR} ${SIMH_TARGET_DIR}

COPY --from=yaze ${YAZE_TARGET_DIR} ${YAZE_TARGET_DIR}
COPY --from=yaze ${ZCIMTOOLS_TARGET_DIR}/bin/yaze ${ZCIMTOOLS_TARGET_DIR}/bin/cdm ${ZCIMTOOLS_TARGET_DIR}/bin/

COPY --from=yazeag ${YAZE_AG_TARGET_DIR} ${YAZE_AG_TARGET_DIR}

COPY --from=z80pack ${Z80PACK_TARGET_DIR} ${Z80PACK_TARGET_DIR}

COPY --from=zcimtools ${ZCIMTOOLS_TARGET_DIR} ${ZCIMTOOLS_TARGET_DIR}

COPY --from=z88dk ${BUILD_DIR}/z88dk/bin/ ${Z88DK_TARGET_DIR}/bin/
COPY --from=z88dk ${BUILD_DIR}/z88dk/doc/ ${Z88DK_TARGET_DIR}/doc/
COPY --from=z88dk ${BUILD_DIR}/z88dk/examples/ ${Z88DK_TARGET_DIR}/examples/
COPY --from=z88dk ${BUILD_DIR}/z88dk/include/ ${Z88DK_TARGET_DIR}/include/
COPY --from=z88dk ${BUILD_DIR}/z88dk/lib/ ${Z88DK_TARGET_DIR}/lib/
COPY --from=z88dk ${BUILD_DIR}/z88dk/libsrc/ ${Z88DK_TARGET_DIR}/libsrc/

COPY --chown=${TOOL_USER}:${TOOL_USER} src/ src/

# ENV LD_LIBRARY_PATH=${ZCIMTOOLS_TARGET_DIR}/lib:${LD_LIBRARY_PATH}

VOLUME [ "/work" ]

CMD [ "/bin/bash" ]
