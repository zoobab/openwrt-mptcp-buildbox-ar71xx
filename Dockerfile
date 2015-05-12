FROM debian:wheezy

# Make sure the package repository is up to date
RUN apt-get update
RUN apt-get -y upgrade

# Install prerequisite packages for OpenWrt BuildRoot
RUN apt-get -y install build-essential subversion git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip wget

# NOTE: Uncomment if user "build" is not already created inside the base image
## Create non-root user that will perform the build of the images
RUN useradd --shell /bin/bash build
RUN mkdir -p /home/build
RUN chown -R build /home/build

RUN su build -c "cd ~ && git clone https://github.com/xedp3x/openwrt.git"
RUN su build -c "cd ~/openwrt && ./scripts/feeds update -a" build
RUN su build -c "cd ~/openwrt && ./scripts/feeds install -a" build
RUN su build -c "cd ~/openwrt && echo CONFIG_TARGET_ar71xx=y > .config"
RUN su build -c "cd ~/openwrt && make defconfig"
RUN su build -c "cd ~/openwrt && make prereq"
RUN su build -c "cd ~/openwrt && make tools/install"
RUN su build -c "cd ~/openwrt && make toolchain/install"
RUN su build -c "cd ~/openwrt && make -j3 -v"

# EOF
