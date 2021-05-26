FROM ubuntu:20.04

LABEL maintainer Robert Schilling <robert.schilling@iaik.tugraz.at>

# Install commonly used packages for c++ development. Additionally,
# update-alternatives is configured to simplify use of alternative tools. For
# example, using gold as default linker
#   `update-alternatives --set ld /usr/bin/ld.gold`.

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#
# When ccache should be used, the path has to be extended as follows:
# `export PATH="/usr/lib/ccache:$PATH"`. Note that the default cache directory
# of ccache can be configured by exporting `CCACHE_DIR`.
RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  autopoint \
  bison \
  build-essential \
  ccache \
  clang \
  clang-format \
  clang-tidy \
  cmake \
  curl \
  doxygen \
  flex \
  gcc-multilib \
  g++-multilib \
  git \
  graphviz \
  lcov \
  libboost-all-dev \
  libsqlite3-dev \
  libssl-dev \
  ninja-build \
  python3 \
  python3-pip \
  valgrind \
  wget \
  gperf \
  pkg-config \
  && pip3 install --upgrade conan conan_package_tools \
  && update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 10 \
  && update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 20

# Build and install a reasonable modern cmake version. 
RUN git clone https://gitlab.kitware.com/cmake/cmake.git /tmp/cmake \
  && mkdir /tmp/cmake/_build \
  && cd /tmp/cmake/_build \
  && git checkout v3.20.2 \
  && ./../bootstrap --parallel=4 -- -DCMAKE_BUILD_TYPE=Release \
  && make -j4 install \
  && rm -rf /tmp/cmake
