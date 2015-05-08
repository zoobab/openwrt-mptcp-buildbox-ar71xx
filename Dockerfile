FROM debian:wheezy

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential subversion git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip wget

RUN useradd --shell /bin/bash build
RUN mkdir -p /home/build
RUN chown -R build /home/build

RUN su build -c "cd ~ && git clone https://github.com/xedp3x/openwrt.git"
RUN su build -c "cd ~/openwrt && ./scripts/feeds update -a"
RUN su build -c "cd ~/openwrt && ./scripts/feeds install -a"
RUN su build -c "cd ~/openwrt && echo CONFIG_TARGET_ar71xx=y > .config"
RUN su build -c "cd ~/openwrt && make defconfig"
RUN su build -c "cd ~/openwrt && make prereq"
RUN su build -c "cd ~/openwrt && make tools/install"
RUN su build -c "cd ~/openwrt && make toolcahin/install"
