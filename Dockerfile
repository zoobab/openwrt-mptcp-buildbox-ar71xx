FROM debian:wheezy

# Make sure the package repository is up to date
RUN apt-get update
RUN apt-get -y upgrade

# Install prerequisite packages for OpenWrt BuildRoot
RUN apt-get -y install build-essential subversion git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip

# NOTE: Uncomment if user "build" is not already created inside the base image
## Create non-root user that will perform the build of the images
RUN useradd --shell /bin/bash build
RUN mkdir -p /home/build
RUN chown -R build /home/build

# 2. Download the OpenWrt bleeding edge with git
RUN su -c "cd ~ && git clone https://github.com/xedp3x/openwrt.git" build

# 3. (optional) Download and install all available "feeds"
RUN su -c "cd ~/openwrt && ./scripts/feeds update -a" build
RUN su -c "cd ~/openwrt && ./scripts/feeds install -a" build

# 4. Make OpenWrt Buildroot check for missing packages on your build-system
RUN su -c "cd ~/openwrt && make defconfig" build
RUN su -c "cd ~/openwrt && make prereq" build
RUN cat /proc/cpuinfo
RUN cat /proc/meminfo
RUN su -c "cd ~/openwrt && make -j4" build

# EOF
