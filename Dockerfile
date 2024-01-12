FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN (rm -rf /var/lib/apt/lists/* && \
    echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install cmake make ninja-build git curl ca-certificates bzip2 xz-utils coreutils gnupg2 libpcre3-dev g++ python3-pip python3-empy python3-pexpect  && \
    rm -rf /var/lib/apt/lists/*) && \
# (cd /tmp && \
#     curl -SOL https://github.com/danmar/cppcheck/archive/refs/tags/2.13.0.tar.gz && \
#     tar xvf 2.13.0.tar.gz && \
#     cd cppcheck-2.13.0 && \
#     make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" -j4 && \
#     make install FILESDIR=/usr/share/cppcheck && \
#     rm -rf /tmp/*) && \
(cd /tmp && \
    curl -SOL https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
    printf "97dbb4f019ad1650b732faffcc881689cedc14e2b7ee863d390e0a41ef16c9a3 */tmp/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2" > /tmp/toolchain.shasum && \
    sha256sum --check --status /tmp/toolchain.shasum && \
    tar xf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
    cp -r gcc-arm-none-eabi-10.3-2021.10/* /usr/local/ && \
    rm -rf /tmp/*) && \
# (cd /tmp && \
#     curl -SOL https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v13.2.1-1.1/xpack-arm-none-eabi-gcc-13.2.1-1.1-linux-x64.tar.gz && \
#     printf "1252a8cafe9237de27a765376697230368eec21db44dc3f1edeb8d838dabd530  */tmp/xpack-arm-none-eabi-gcc-13.2.1-1.1-linux-x64.tar.gz" > /tmp/toolchain.shasum && \
#     sha256sum --check --status /tmp/toolchain.shasum && \
#     tar xf xpack-arm-none-eabi-gcc-13.2.1-1.1-linux-x64.tar.gz && \
#     cp -r xpack-arm-none-eabi-gcc-13.2.1-1.1/* /usr/local/ && \
#     rm -rf /tmp/*) && \
# (cd /tmp && \
#     curl -SOL https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-17.0.1/LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz && \
#     printf "eb7bff945d3c19589ab596a9829de6f05f86b73f52f80da253232360c99ea68f */tmp/LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz" > /tmp/toolchain.shasum && \
#     sha256sum --check --status /tmp/toolchain.shasum && \
#     tar xf LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz && \
#     cp -r LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64/* /usr/local/ && \
#     rm -rf /tmp/*) && \
(cd /tmp && \
    curl -SOL https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 && \
    mv tini-static-amd64 /usr/local/bin/tini && \
    chmod u+x /usr/local/bin/tini && \
    rm -rf /tmp/*)

ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash"]

