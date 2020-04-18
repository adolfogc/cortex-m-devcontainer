FROM debian:buster-slim

RUN (rm -rf /var/lib/apt/lists/* && \
    echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install cmake make ninja-build git curl ca-certificates bzip2 coreutils gnupg2 && \
    curl -SL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install -y clang-format clang-tidy clang-tools clang libpcre3-dev g++ && \
    rm -rf /var/lib/apt/lists/*) && \
(cd /tmp && \
    curl -SOL https://github.com/danmar/cppcheck/archive/1.90.tar.gz && \
    tar xvf 1.90.tar.gz && \
    cd cppcheck-1.90 && \
    make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" -j4 && \
    make install FILESDIR=/usr/share/cppcheck && \
    rm -rf /tmp/*) && \
(cd /tmp && \
    curl -SOL https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 && \
    printf "bcd840f839d5bf49279638e9f67890b2ef3a7c9c7a9b25271e83ec4ff41d177a */tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2" > /tmp/toolchain.shasum && \
    sha256sum --check --status /tmp/toolchain.shasum && \
    tar xf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 && \
    cp -r gcc-arm-none-eabi-9-2019-q4-major/* /usr/local/ && \
    curl -SOL https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 && \
    mv tini-static-amd64 /usr/local/bin/tini && \
    chmod u+x /usr/local/bin/tini && \
    rm -rf /tmp/*)

ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash"]

