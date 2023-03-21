FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN (rm -rf /var/lib/apt/lists/* && \
    echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install cmake make ninja-build git curl ca-certificates bzip2 coreutils gnupg2 libpcre3-dev g++ python3-pip && \
    curl -SL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-16 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-16 main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y install clang-16 clang-tools-16 clang-16-doc libclang-common-16-dev libclang-16-dev libclang1-16 clang-format-16 python3-clang-16 clangd-16 clang-tidy-16 && \
    rm -rf /var/lib/apt/lists/*) && \
(set -x && \
    ln -s /usr/bin/clang-16  /usr/local/bin/clang && \
    ln -s /usr/bin/clang++-16  /usr/local/bin/clang++ && \
    ln -s /usr/bin/clangd-16 /usr/local/bin/clangd && \
    ln -s /usr/bin/clang-format-16 /usr/local/bin/clang-format && \
    ln -s /usr/bin/clang-tidy-16 /usr/local/bin/clang-tidy) && \
(cd /tmp && \
    curl -SOL https://github.com/danmar/cppcheck/archive/2.10.tar.gz && \
    tar xvf 2.10.tar.gz && \
    cd cppcheck-2.10 && \
    make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" -j4 && \
    make install FILESDIR=/usr/share/cppcheck && \
    rm -rf /tmp/*) && \
(cd /tmp && \
    curl -SOL https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
    printf "97dbb4f019ad1650b732faffcc881689cedc14e2b7ee863d390e0a41ef16c9a3 */tmp/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2" > /tmp/toolchain.shasum && \
    sha256sum --check --status /tmp/toolchain.shasum && \
    tar xf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
    cp -r gcc-arm-none-eabi-10.3-2021.10/* /usr/local/ && \
    curl -SOL https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 && \
    mv tini-static-amd64 /usr/local/bin/tini && \
    chmod u+x /usr/local/bin/tini && \
    rm -rf /tmp/*) && \
(pip3 install empy pexpect)

ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash"]

